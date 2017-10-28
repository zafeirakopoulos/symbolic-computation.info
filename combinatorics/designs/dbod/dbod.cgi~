#!/usr/bin/python

# Required header that tells the browser how to render the text.

import sqlite3
import cgi


def input_page():
# Required header that tells the browser how to render the HTML.
    print "<HTML>\n"
    print "<HEAD>\n"
    print "\t<TITLE>Input New Data</TITLE>\n"
    print "</HEAD>\n"
    print "<BODY BGCOLOR = white>\n"

    print "\t\t<FORM METHOD = post ACTION = \"dbod.cgi\">\n"
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
        
    print "\t<INPUT TYPE = hidden NAME = \"action\" VALUE =\"confirm\">\n"
    print "\t<INPUT TYPE = submit VALUE = \"Enter\">\n"
    print "\t</FORM>\n"
        
    print "</BODY>\n"
    print "</HTML>\n"


def confirm_input(order,type,nvar,open,a1,a2,a3,a4,paf,npaf,method,ref):
    print order,type,nvar,open,a1,a2,a3,a4,paf,npaf,method,ref
    print "<HTML>\n"
    print "<HEAD>\n"
    print "\t<TITLE>Confirm Data</TITLE>\n"
    print "</HEAD>\n"
    print "<BODY BGCOLOR = white>\n"
    print "Confirm that the following data are correct:"
    print "\t\t<FORM METHOD = post ACTION = \"dbod.cgi\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"action\" VALUE =\"commit\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"order\" VALUE =\""+str(order)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"type\" VALUE =\""+str(type)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"nvar\" VALUE =\""+str(nvar)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"open\" VALUE =\""+str(open)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"a1\" VALUE =\""+str(a1)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"a2\" VALUE =\""+str(a2)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"a3\" VALUE =\""+str(a3)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"a4\" VALUE =\""+str(a4)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"paf\" VALUE =\""+str(paf)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"npaf\" VALUE =\""+str(npaf)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"method\" VALUE =\""+str(method)+"\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"ref\" VALUE =\""+str(ref)+"\">\n"
    print "\t<INPUT TYPE = submit VALUE = \"Confirm\">\n"
    print "\t</FORM>\n"
    print "</BODY>\n"
    print "</HTML>\n"

def commit_input(order,type,nvar,open,a1,a2,a3,a4,paf,npaf,method,ref):
    conn=sqlite3.connect("/home/www/people/zafeirak/dbod/dbod.sqlite")
    cur=conn.cursor()
    try:
        t = (order,type,nvar,open)
        cur.execute("SELECT * FROM Type WHERE ord='"+order+"' AND type='"+type+"'")
        tmp=cur.fetchone()
        if tmp!=None:
            tid=tmp[0]        
        else:
            cur.execute('INSERT INTO Type(ord,type,nvar,open) VALUES(?,?,?,?)',t)
            tid=cur.lastrowid
        #print "<br> Type ok"
        s = (a1,a2,a3,a4,paf,npaf)
        cur.execute('INSERT INTO Sequence(a1,a2,a3,a4,paf,npaf) VALUES(?,?,?,?,?,?)',s)
        sid=cur.lastrowid
        #print "<br> Sequence ok"
        r= (sid,method,ref)
        cur.execute('INSERT INTO Source(sid,method,ref) VALUES(?,?,?)',r)
        rid=cur.lastrowid
        #print "<br> Source ok"  
        w= (tid,sid)
        cur.execute('INSERT INTO Witness(tid,sid) VALUES(?,?)',w)
        wid=cur.lastrowid
        #print "<br> Witness ok"        
    except Exception:        
        print "Exception: Could not execute query"  
    conn.commit()
    cur.close()
    print "<HTML>\n"
    print "<HEAD>\n"
    print "\t<TITLE>Data Commited</TITLE>\n"
    print "</HEAD>\n"
    print "<BODY BGCOLOR = white>\n"
    print "Data commited in the database succesfully."
    print "\t\t<FORM METHOD = post ACTION = \"dbod.cgi\">\n"
    print "\t<INPUT TYPE = submit VALUE = \"Next\">\n"
    print "\t</FORM>\n"
    print "</BODY>\n"
    print "</HTML>\n"    
                        
    # Define main function.
def main():
    print "Content-Type: text/html\n\n"
    form = cgi.FieldStorage()
    if form.has_key("action"):
        if (form["action"].value == "confirm"):
            if form.has_key("open"):
                openval="1"
            else:
                openval="0"
            if form.has_key("paf"):
                pafval="1"
            else:
                pafval="0"
            if form.has_key("npaf"):
                npafval="1"
            else:
                npafval="0"
            confirm_input(form["order"].value, form["type"].value,form["nvar"].value,openval,form["a1"].value,form["a2"].value, form["a3"].value,form["a4"].value,pafval, npafval,form["method"].value, form["ref"].value)
        if (form["action"].value == "commit"):
            commit_input(form["order"].value, form["type"].value,form["nvar"].value,form["open"].value,form["a1"].value,form["a2"].value, form["a3"].value,form["a4"].value,form["paf"].value, form["npaf"].value,form["method"].value, form["ref"].value)        
          
    else:
        input_page()
          
# Call main function. 
main()

    
