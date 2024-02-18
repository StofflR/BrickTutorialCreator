from modules.OSDefs import *
from modules.ConstDefs import *
import os
import shutil
import random
import string


def randomString(digits: int) -> str:
    """
    Parameters
    ----------
    digits : the number of digits of the random string

    Returns
    -------
    a random string of the given length
    """
    assert digits >= 0
    return "".join(
        random.SystemRandom().choice(string.ascii_letters + string.digits)
        for _ in range(digits)
    )


def clearFolder(root_path: str) -> None:
    """

    Parameters
    ----------
    root_path : the root path whose contents will be deleted

    Returns
    -------
    Clear all the files in the given folder
    """
    for filename in os.listdir(root_path):
        file_path = os.path.join(root_path, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print("Failed to delete %s. Reason: %s" % (file_path, e))


def generateRequiredFolders():
    """
    Returns None
    -------
    Create all the necessary folders if they are not present
    """
    if not os.path.isdir(DEF_RESOURCE):
        os.makedirs(DEF_RESOURCE)
    if not os.path.isdir(DEF_RESOURCE_OUT):
        os.makedirs(DEF_RESOURCE_OUT)
    if not os.path.isdir(DEF_RESOURCE_OUT_EXPORT):
        os.makedirs(DEF_RESOURCE_OUT_EXPORT)
    if not os.path.isdir(DEF_TMP):
        os.makedirs(DEF_TMP)


def removeFileStub(path: str) -> str:
    """
    return str
    Removes the operating system dependant file stub
    """
    return path.replace(FILE_STUB, "")


def addFileStub(path: str) -> str:
    """
    return str
    Add the operating system dependant file stub if not present
    """
    return path if FILE_STUB in path else FILE_STUB + path


def isFileType(path, file_extension) -> bool:
    """
    return bool
    Check if the file extension is present in the given path
    """
    return file_extension in path


def extendFileExtension(path, file_extension) -> str:
    """
    return str
    Appends the file extension to the given path
    """
    assert path != "" and file_extension != ""
    return path if isFileType(path, file_extension) else path + file_extension
