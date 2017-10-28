#!/usr/bin/python

# Required header that tells the browser how to render the text.

import sqlite3
import cgi

def get_cursor(dbname):
    return sqlite3.connect(dbname).cursor()
    

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
    print "\t\t<TR><TH>PAF:</TH><TD><INPUT type = checkbox name = \"paf\"></TD><TR>\n"
    print "\t\t<TR><TH>NPAF:</TH><TD><INPUT type = checkbox name = \"npaf\"></TD><TR>\n"
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

   
#def confirm_input(type, sequence, reference, normal, method):
def confirm_input(order,type,nvar,open,a1,a2,a3,a4,paf,npaf,method,ref):
    print "<HTML>\n"
    print "<HEAD>\n"
    print "\t<TITLE>Confirm Data</TITLE>\n"
    print "</HEAD>\n"
    print "<BODY BGCOLOR = white>\n"
    print order,type,nvar,open,a1,a2,a3,a4,paf,npaf,method,ref
    print "\t\t<FORM METHOD = post ACTION = \"dbod.cgi\">\n"
    print "\t<INPUT TYPE = hidden NAME = \"action\" VALUE =\"commit\">\n"
    print "\t<INPUT TYPE = submit VALUE = \"Confirm\">\n"
    print "\t</FORM>\n"
    print "</BODY>\n"
    print "</HTML>\n"

    # Define main function.
def main():
    print "Content-Type: text/html\n\n"
    form = cgi.FieldStorage()
    if form.has_key("action"):
        if (form["action"].value == "confirm"):
            confirm_input(form["name"].value, form["age"].value)
        if (form["action"].value == "commit"):
            print "Commit time"
            
    else:
        input_page()
          

# Call main function.
 
main()

    


# Create table
#cur.execute('''create table stocks(date text, trans text, symbol text, qty real, price real)''')

# Insert a row of data
#cur.execute("""insert into stocks values ('2006-01-05','BUY','RHAT',100,35.14)""")

# Save (commit) the changes
#conn.commit()

# We can also close the cursor if we are done with it
#cur.close()


# Print a simple message to the display window.
#print "Hello, World!\n" 
