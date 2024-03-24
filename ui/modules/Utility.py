import modules.OSDefs as OSDefs
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
    if not os.path.isfile(DEF_BASE_BRICK):
        with open(os.path.join(DEF_RESOURCE, "base_1h.svg"), "r") as file:
            filedata = file.read()
            filedata = (
                filedata.replace("BACKGROUND", "408ac5")
                .replace("SHADE", "27567c")
                .replace("BORDER", "383838")
            )
        with open(DEF_BASE_BRICK, "w") as file:
            file.write(filedata)


def removeFileStub(path: str) -> str:
    """
    return str
    Removes the operating system dependant file stub
    """
    return path.replace(OSDefs.FILE_STUB, "")


def addFileStub(path: str) -> str:
    """
    return str
    Add the operating system dependant file stub if not present
    """
    return path if OSDefs.FILE_STUB in path else OSDefs.FILE_STUB + path


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


def getAttr(text, attr, default_value):
    """
    Retrieve attribute from dict or return default value
    Parameters
    ----------
    text: dict to retrieve attribute from
    attr: attribute to be retrieved
    default_value: default value to be returned
    Returns
    -------
    the attribute if present or the default value
    """
    return default_value if text == "" or attr not in text.keys() else text[attr]


def cleanFileName(filename: str) -> str:
    """
    Remove forbidden characters from text
    Parameters
    ----------
    filename: the filename where forbidden chars should be removed
    Returns
    -------
    string without forbidden characters
    """
    name = filename.replace(SVG_EXT, "").replace(PNG_EXT, "").replace(JSON_EXT, "")
    for key, value in FORBIDDEN_FILE_NAME_CHARS.items():
        name = name.replace(key, value)
    return name


def getHeight(size: str, base_type: str) -> float:
    if size == "1h":
        if "control" in base_type:
            return PNG_HEIGHT_1H_CONTROL
        return PNG_HEIGHT_1H
    if size == "2h":
        if "control" in base_type:
            return PNG_HEIGHT_2H_CONTROL
        return PNG_HEIGHT_2H
    if size == "3h":
        return PNG_HEIGHT_3H
    return PNG_HEIGHT_0H
