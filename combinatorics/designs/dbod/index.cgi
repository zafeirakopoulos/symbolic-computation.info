#!/usr/bin/python

# Required header that tells the browser how to render the text.

import sqlite3
import cgi


def select_page():
# Required header that tells the browser how to render the HTML.
    print "<HTML>\n"
    print "<HEAD>\n"
    print "\t<TITLE>Input New Data</TITLE>\n"
    print "</HEAD>\n"
    print "<BODY BGCOLOR = white>\n"

    print "\t\t<FORM METHOD = post ACTION = \"index.cgi\">\n"
    print "\t<H3>Type:</H3>\n"
    print "\t<TABLE BORDER = 1>\n"
    print "\t\t<TR><TH>Order:</TH><TD><INPUT type = text name = \"order\"></TD><TR>\n"
    print "\t\t<TR><TH>Type:</TH><TD><INPUT type = text name = \"type\"></TD><TR>\n"
    print "\t\t<TR><TH>Number of variables:</TH><TD><INPUT type = text name = \"nvar\"></TD><TR>\n"
    print "\t\t<TR><TH>Open Case:</TH><TD><INPUT type = checkbox name = \"open\"></TD><TR>\n"
    print "\t</TABLE>\n"
    
    print "\t<H3>4-tuple:</H3>\n"
    print "\t<TABLE BORDER = 1>\n"
    print "\t\t<TR><TH>1st Sequence:</TH><TD><INPUT type = text name = \"a1\"></TD><TR>\n"
    print "\t\t<TR><TH>2nd Sequence:</TH><TD><INPUT type = text name = \"a2\"></TD><TR>\n"    
    print "\t\t<TR><TH>3rd Sequence:</TH><TD><INPUT type = text name = \"a3\"></TD><TR>\n"
    print "\t\t<TR><TH>4th Sequence:</TH><TD><INPUT type = text name = \"a4\"></TD><TR>\n"    
    print "\t\t<TR><TH>PAF:</TH><TD><INPUT type = checkbox name = \"paf\" ></TD><TR>\n"
    print "\t\t<TR><TH>NPAF:</TH><TD><INPUT type = checkbox name = \"npaf\" ></TD><TR>\n"
    print "\t</TABLE>\n"

    print "\t<H3>Source:</H3>\n"
    print "\t<TABLE BORDER = 1>\n"
    print "\t\t<TR><TH>Method:</TH><TD><INPUT type = text name = \"method\"></TD><TR>\n"
    print "\t\t<TR><TH>Reference:</TH><TD><INPUT type = text name = \"ref\"></TD><TR>\n"    
    print "\t</TABLE>\n"
        
    print "\t<INPUT TYPE = hidden NAME = \"action\" VALUE =\"show\">\n"
    print "\t<INPUT TYPE = submit VALUE = \"Show\">\n"
    print "\t</FORM>\n"
        
    print "</BODY>\n"
    print "</HTML>\n"

                        
def show_data(order,type,nvar,open,a1,a2,a3,a4,paf,npaf,method,ref):
    q="SELECT * FROM Type t, Sequence s, Witness w, Source r WHERE "
    tmpq=[]
    if order!="":
        tmpq.append(" t.ord='"+order+"' ")
    if type!="":
        tmpq.append(" t.type='"+type+"' ")
    if nvar!="":
        tmpq.append(" t.nvar='"+nvar+"' ")
    if open!="":
        tmpq.append(" t.open='"+open+"' ")
    if paf!="":
        tmpq.append(" s.paf='"+paf+"' ")
    if npaf!="":
        tmpq.append(" s.npaf='"+npaf+"' ")
    q+= " AND ".join(tmpq)
    q+= " AND r.sid=s.id AND s.id=w.sid AND t.id=w.tid"
    conn=sqlite3.connect("/home/www/people/zafeirak/dbod/dbod.sqlite")
    cur=conn.cursor()
    cur.execute(q)
    c=cur.fetchall()
    print "The following results match your criteria: <br>"
    print "<table border= 1>\n"
    print "<tr><td>Order</td><td>Type</td><td>#variables</td><td>Open</td><td>Sequences</td><td>PAF</td><td>NPAF</td><td>Method</td><td>Reference</td></tr>"
    for i in c:
        print "<tr><td>"+str(i[1])+"</td><td>"+str(i[2])+"</td><td>"+str(i[3])+"</td><td>"+str(i[4])+"</td><td>"+str(i[6])+" | "+str(i[7])+" | "+ str(i[8])+" | "+str(i[9])+"</td><td>"+str(i[10])+"</td><td>"+str(i[11])+"</td><td>"+str(i[19])+"</td><td>"+str(i[20])+"</td></tr>"     
    print "</table>"
    cur.close()
    
    
                                       
    # Define main function.
def main():
  #  test("44","1,2,3,4","","","","","","","","","","")
    print "Content-Type: text/html\n\n"
    form = cgi.FieldStorage()
    if form.has_key("action"):
        if (form["action"].value == "show"):
            if form.has_key("open"):
                openval="1"
            else:
                openval=""
            if form.has_key("paf"):
                pafval="1"
            else:
                pafval=""
            if form.has_key("npaf"):
                npafval="1"
            else:
                npafval=""
            if form.has_key("order"):
                order=form["order"].value
            else:
                order=""                            
            if form.has_key("order"):
                order=form["order"].value
            else:
                order=""                            
            if form.has_key("nvar"):
                nvar=form["nvar"].value
            else:
                nvar=""                            
            if form.has_key("type"):
                type=form["type"].value
            else:
                type=""                            
            if form.has_key("ref"):
                ref=form["ref"].value
            else:
                ref=""                            
            if form.has_key("method"):
                method=form["method"].value
            else:
                method=""                            
            if form.has_key("a1"):
                a1=form["a1"].value
            else:
                a1=""                            
            if form.has_key("a2"):
                a2=form["a2"].value
            else:
                a2=""
            if form.has_key("a3"):
                a3=form["a3"].value
            else:
                a3=""
            if form.has_key("a4"):
                a4=form["a4"].value
            else:
                a4=""                                    
            show_data(order,type,nvar,openval,a1,a2,a3,a4,pafval, npafval,method, ref)
    else:
        select_page()
          

# Call main function.
 
main()

    
