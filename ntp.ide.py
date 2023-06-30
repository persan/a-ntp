import GPS
import os.path

def initialize_project_plugin():
    if GPS.Project.root().name() != "NTP.Tests":
        GPS.Project.load("tests/ntp-tests.gpr", force=True)

def finalize_project_plugin():
    pass
