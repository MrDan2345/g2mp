FPTemplate examples
===================
These examples demonstrate some uses of templates (with FPTemplate) when 
generating HTML pages by CGI/FCGI programs or Apache modules.

The main idea is to leave the web page design and look&feel to the web page 
designers. Separating the web page design from the back-end CGI/FCGI/Apache 
application makes it possible to design, change or redesign a whole website 
without modifying a single line of code in the CGI/FCGI/Apache application. 

Back-end programmers and web page designers can easily work parallel, and 
neither side needs extensive knowledge of the other (does not hurt, just not 
necessary most of the time). 

With all this said, none of the examples are focusing on nice look and feel in 
their template designs, merely on demonstrating the functionality and use of 
templates, template-tags and template-tag-parameters with live applications.


Examples list:

1. /simpletemplate/*.*
The simplest template with one template tag in it to be replaced by the 
CGI/FCGI/Apache application when generating the response page -> {TagName1}
See README.txt

2. /tagparam/*.*
Demonstrates the set up and use of template tag parameter(s) 
-> {+DATETIME [-FORMAT=MM/DD hh:mm:ss-]+}

3. /listrecords/*.*
Demonstrates the use of a template tag with multiple template tag parameters 
to list multiple records, tables, lists, etc.
See README.txt

4. /fileupload/*.*
Demonstrates uploading file(s) to a web server with the help of a CGI/FCGI 
program or Apache module by using so called "multipart" HTML forms.
See README.txt
                                
5. /sessions/*.*
These examples demonstrate three different ways to maintain and use sessions 
when building web sites that need to carry over or store information to 
following web pages, differentiate between visitors, etc.

5.a. /sessions/cookiesessions-auto/*.*
See README.txt

5.b. /sessions/cookiesessions-login/*.*
See README.txt

5.c. /sessions/urlsessions-login/*.*
See README.txt

6. /embedtemplates/*.*
An example to show how to implement recursively embedded templates with fpweb.
See README.txt

Note: All of the examples have CGI, FCGI and Apache variations. The web 
modules (webmodule.pas, webmodule.lfm) and template html files for the paired 
CGI/FCGI/Apache applications are exactly the same, showing that from a 
developer standpoint there is not too much difference between writing CGI/FCGI 
programs or Apache modules with fcl-web (fpweb). The main differences are in 
the main project files (.lpr) and in the web server configurations.
