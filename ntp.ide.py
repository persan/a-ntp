
import GPS


def initialize_project_plugin():
    GPS.Project.load("tests/ntp-tests.gpr", force=True)


def finalize_project_plugin():
    pass
