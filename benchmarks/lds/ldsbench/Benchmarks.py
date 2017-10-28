# -*- coding: iso-8859-1 -*-
from jinja2 import Environment, FileSystemLoader
import json
import subprocess, threading
import sys
import os
import warnings
import time
import signal

from Queue import Queue, Empty
#from subprocess import PIPE, Popen
#from threading  import Thread

class Bench(object):

    # The path to the user folder for the benchmarks
    benchpath=None

    # The path to the benchit system folder
    systempath=None

    # The folder where output and errors are stored
    outfolder=None
    errfolder=None

    # The template environments
    bench_env = None
    methods_env = None
    systems_env = None


    methods={}
    instances={}
    datasets=None


    methods_tmpl={}
    systems_tmpl={}
    benchmarks=[]

    #benchfolder is the folder where the definitions are
    def __init__(self,benchfolder):
        # Set the system folder
        self.systempath=os.path.join(os.getcwd(),"benchit")

        # Set the user benchmarks folder
        self.benchpath=os.path.join(os.getcwd(),benchfolder)

        #The file with the definition of the benchmarks must be in benchfolder
        # and named definition.json
        definition_path=os.path.join(self.benchpath,"definition.json")
        if not os.path.exists(definition_path):
            raise Exception("Benchmark definition not found.")
        try:
            definition_file=open(definition_path)
        except Exception:
            raise Exception("Benchmark definition file could not open.")
        self.definition=json.load(definition_file)


        # Create an environment for the system templates
        self.bench_env = Environment(loader=FileSystemLoader(os.path.join(self.systempath,"templates")))

        # Create an environment for each computer algebra system supported
        self.systems_env = Environment(loader=FileSystemLoader(os.path.join(self.systempath,"systems")))

        # Create an environment for the templates related to methods
        self.methods_env = Environment(loader=FileSystemLoader(os.path.join(self.benchpath,"methods")))

        # Populate the methods and instances disctionaries
        self.read_methods(self.definition["basic"]["methods"])
        self.read_instances(self.definition["basic"]["instances"], self.definition["instances"])


    def read_methods(self,methodsfile):
        # The list of methods is given in the definition.json
        methods_list=self.definition["methods"]

        # Create the templates for the systems used
        for i in [ method["system"] for method in methods_list]:
            try:
                # Read the template corresponfing to this computer algebra
                # system from the benchit/systems folder
                self.systems_tmpl[i]= self.systems_env.get_template(str(i)+".tmpl")
                # If it succeeds, put the method in the dictionary of methods
                self.methods[method["id"]]=method
            except Exception:
                raise Exception("Could not load initialization template for "+str(i)+".")

        # For each method load the templates related to it from the user folder
        for method_id in self.methods.keys():
            pre=self.methods_env.get_template(os.path.join(method_id, "pre.tmpl"))
            exe=self.methods_env.get_template(os.path.join(method_id, "execute.tmpl"))
            post=self.methods_env.get_template(os.path.join(method_id, "post.tmpl"))
            # Put the templates as a dictionary in the dictionary of method templates.
            self.methods_tmpl[str(method["id"])]={"pre":pre, "execute":exe,"post":post}


    def read_instances(self,instancesfolder,instancesfile):
        instances_path=os.path.join(self.benchpath,instancesfolder,instancesfile+".json")
        if not os.path.exists(instances_path):
            raise Exception(instances_path+" is not a valid path.")
        try:
            instances_file=open(instances_path)
        except Exception:
            raise Exception("Instances file could not open.")

        instances_list=json.load(instances_file)
        for instance in instances_list:
            self.instances[instance["id"]]=instance


    def create_benchmarks(self,methods=None,instances=None):
        if methods==None:
            methods=self.methods.keys()
        if instances==None:
            instances=self.instances.keys()
        for m in methods:
            for i in instances:
                self.benchmarks.append(Benchmark(self,str(m),str(i)))


    def run_benchmarks(self, timeout=0):
        for b in self.benchmarks:
            b.run(timeout)



class Benchmark(object):
    bench=None
    method=None
    instance=None
    outfile=None
    outfile_path=None    
    errfile=None
    command=None
    codefile=None
    infile=None
 
    def __init__(self,bench,method_id,instance_id):
        # Setting the environment
        self.bench=bench

        # Read the method and the instance related to this benchmark
        self.method=bench.methods[str(method_id)]
        self.instance=bench.instances[str(instance_id)]

        ## The ouput file is stored in tmp
        #self.outfile_path=os.path.join(self.bench.benchpath,"tmp",str(method_id)+"_"+str(instance_id)+".out")
        #if os.path.exists(self.outfile_path):
            #warnings.warn(Warning(self.outfile_path+" already exists."),stacklevel=2)
        #try:
            ## Open the same file for reading and writing
            ## TODO: Can this be a problem?
            #self.outfile=open(self.outfile_path,"w+")
        #except Exception:
            #raise Exception("Outfile could not open.")

        ## The file where errors are redirected
        #errfile_path=os.path.join(self.bench.benchpath,"tmp",str(method_id)+"_"+str(instance_id)+".err")
        #if os.path.exists(errfile_path):
            #warnings.warn(Warning(errfile_path+" already exists!"),stacklevel=2)
        #try:
            #self.errfile=open(errfile_path,"w")
        #except Exception:
            #raise Exception("Errfile could not open.")

        # The file where the generated code is stored
        codefile_path=os.path.join(self.bench.benchpath,"tmp",str(method_id)+"_"+str(instance_id)+".code")
        if os.path.exists(codefile_path):
            warnings.warn(Warning(codefile_path+" already exists."),stacklevel=2)
        try:
            self.codefile=open(codefile_path,"w")
        except Exception:
            raise Exception("Codefile could not open.")


        rendered={}
        # This script takes no arguments because it has to be independant from the
        # particular instance. It is an initialization script.
        rendered["prescript"]= bench.methods_tmpl[str(method_id)]["pre"].render(self.instance)

        # The second script accepts parameters. These are given in the dictionary
        # The attributes of the instance and the parameters for the methos
        newdict= dict(self.instance.items() + self.method["parameters"].items())
        rendered["execute"]= bench.methods_tmpl[str(method_id)]["execute"].render(newdict)

        # This script takes no arguments because it has to be independant from the
        # particular instance. It is a finalization script.
        rendered["postscript"]= bench.methods_tmpl[str(method_id)]["post"].render()

        # Accoeding to the template for the system the code is generated
        code=bench.systems_tmpl[self.method["system"]].render(rendered)
        # And writen in the file
        self.codefile.write(code)
        self.codefile.close()

        # TODO: update this to be given by template
        call= self.method["system_call"] + " " + codefile_path
        #call= "time ls"

        # Create a Command object to be run in order to execute the benchmark.
        self.command=Command(call,self.outfile,self.errfile)


    def run(self, mtime=0):
        # Run the code for this benchmark
        self.command.run(timeout=mtime)


class Command(object):

    outfile=None
    errfile=None
    process=None

    pretime=None
    posttime=None
    ptime=None
    potime=None
    tmpid=None

    timereader=None

    def __init__(self, cmd,outfile,errfile):
        self.cmd = cmd
        self.process = None
 
    def run(self, timeout):
        print "----------------"

        def reader(out):
            for line in iter(out.readline, b''):
                print line
            out.close()

        def target():
            print 'Thread started'
            #For large output one should not use pipes.
            #self.process = subprocess.Popen(self.cmd, shell=True, stdout=self.outfile, stderr=self.errfile)
            self.process = subprocess.Popen(self.cmd, shell=True, stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            qu = Queue()
            self.timereader = threading.Thread(target=reader, args=(self.process.stdout))
            self.timereader.start()
            print 'Thread finished'

        #def target():
            #print 'Thread started'
            ##For large output one should not use pipes. 
            ##self.process = subprocess.Popen(self.cmd, shell=True, stdout=self.outfile, stderr=self.errfile)
            #self.process = subprocess.Popen(self.cmd, shell=True, stdout=subprocess.PIPE,stderr=subprocess.PIPE, bufsize=1)
            #qu = Queue()
            #self.timereader = threading.Thread(target=reader, args=(self.process.stdout, qu))
            #self.timereader.start()
            ##timereader.daemon = True # thread dies with the program
            #print 'Thread finished'


        thread = threading.Thread(target=target)
        thread.start()


        if timeout==0:
            thread.join()
        else:
            thread.join(timeout)

        if thread.is_alive():
            print 'Terminating process'
            self.process.terminate()
            thread.join()
        self.process.terminate()



class InstanceTiming:
    bench=None
    methods=None
    instance=None
    data=None

    def __init__(self, bench, methods,instance):
        self.methods = methods
        self.instance = instance
        self.bench=bench

        #Iterate over all methods (and combine with the instance)
        for method in methods:

            # The file where errors are redirected
            errfile=None
            errfile_path=os.path.join(self.bench.benchpath,"tmp",str(method)+"_"+str(instance)+".err")
            if not os.path.exists(errfile_path):
                warnings.warn(Warning(errfile_path+" does not exist!"),stacklevel=2)
            try:
                errfile=open(errfile_path,"r")
            except Exception:
                raise Exception("Errfile could not open.")


            # The error stream is not empty. Act accordingly and give a warning.
            if not errfile.read()=="":
                #Mark in the data that there was an error
                warnings.warn(Warning(errfile_path+" is not empty!"),stacklevel=2)

            print "Now the output"
            # The ouput file is stored in tmp
            outfile=None
            outfile_path=os.path.join(self.bench.benchpath,"tmp",str(method)+"_"+str(instance)+".out")
            if not os.path.exists(outfile_path):
                warnings.warn(Warning(outfile_path+" does not exist."),stacklevel=2)
            try:
                # Open the same file for reading and writing
                # TODO: Can this be a problem?
                outfile=open(outfile_path,"r")
            except Exception:
                raise Exception("Outfile could not open.")

            for line in outfile:
                print line

            errfile.close()
            outfile.close()

    def get(self):
        return self.data

from time import sleep
with warnings.catch_warnings():
    #warnings.simplefilter("ignore")
    b=Bench("benchmarks")
    b.create_benchmarks()
    b.run_benchmarks(5)
    #sleep(20)
    #ins=InstanceTiming(b,[1],1)
    #print ins.get()
#for be in b.benchmarks:
    #print "------"
    #print be.instance
    #print be.command.cmd