import GPS
import os.path

def initialize_project_plugin():
    # GPS.HTML.add_doc_directory(os.path.dirname(GPS.Project("ntp").file().name()))
    GPS.GPS.parse_xml('''<index>
   <documentation_file>
      <name>%s</name>
      <descr>rfc 5905</descr>
      <category>RFCs</category>
      <menu>/Help/</menu>
   </documentation_file>
  </index>''' % os.path.abspath("rfc5905.html"))

    GPS.Project.load("tests/ntp-tests.gpr", force=True)

def finalize_project_plugin():
    pass
