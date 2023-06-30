import GPS
from os.path import *



def addHelp():
    rootDir = GPS.Project("ntp").get_attribute_as_string("Project_Dir")
    GPS.parse_xml('''
   <documentation_file>
      <name>%s</name>
      <descr>rfc 5905</descr>
      <category>RFCs</category>
      <menu>/Help/</menu>
   </documentation_file>''' % join(rootDir, "rfc5905.html"))

def initialize_project_plugin():
    pass

def finalize_project_plugin():
    pass

addHelp()
