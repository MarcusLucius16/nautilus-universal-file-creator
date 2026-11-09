import os
import subprocess

from gi.repository import Nautilus, GObject


class NewFileExtension(GObject.GObject, Nautilus.MenuProvider):

    def get_background_items(self, current_folder):
        item = Nautilus.MenuItem(
            name="UniversalFileCreator::Create",
            label="Create New File"
        )
        item.connect("activate", self.create_file, current_folder)
        return [item]

    def create_file(self, menu, current_folder):
        folder = current_folder.get_location().get_path()

        if not folder:
            return

        result = subprocess.run(
            [
                "zenity",
                "--entry",
                "--title=Create New File",
                "--text=Enter filename:",
                "--entry-text=untitled.txt"
            ],
            capture_output=True,
            text=True
        )

        if result.returncode != 0:
            return

        filename = result.stdout.strip()

        if not filename or filename in (".", "..") or "/" in filename:
            return

        path = os.path.join(folder, filename)

        try:
            fd = os.open(path, os.O_CREAT | os.O_EXCL | os.O_WRONLY, 0o666)
            os.close(fd)
        except FileExistsError:
            subprocess.run(["zenity", "--error", "--text=File already exists!"])
        except OSError as error:
            subprocess.run(["zenity", "--error", f"--text={error}"])