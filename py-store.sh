#!/usr/bin/env python3
import pyfiglet
import subprocess
import sys
import time
from rich.console import Console

console = Console()

def banner():
    text = "[[<<\...PY-STore../>>]"
    banner=pyfiglet.figlet_format(text)
    console.print(banner, style="cyan")
banner()
console.print('''
            ==[[....PY-STore v-1.0....]]==

        [[\>>>>.. Easier Linux apps access.. <<<</]]

      [++[[...Created by Genius ( Salvatore-droid )...]]++]
''', style="yellow")


def flatpak_search(app):
    try:
        subprocess.run(["flatpak", "search", app], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error, search not found {app}: {e}")
        sys.exit(1)

def run_app(app_id):
    try:
        subprocess.run(["flatpak", "run", app_id], check=True)
    except subprocess.CalledProcessError as e:
        print(f"An error occured: {e}")
        sys.exit(1)

def check_flatpak():
    try:
        subprocess.run(["which", "flatpak"], 
        stdout=subprocess.DEVNULL, 
        stderr=subprocess.DEVNULL, 
        text=True,
        check=True
        )
        return True
    except subprocess.CalledProcessError:
        return False

def run_command(command):
    try:
        subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, text=True, check=True)
        return True
    except subprocess.CalledProcessError as e:
        return False, e.stderr

def install_flatpak():
    console.print("Updating system...", style="yellow")
    run_command(["sudo", "apt", "update"])
    line()
    console.print("\nInstalling flatpak...", style="yellow")
    run_command(["sudo", "apt", "install", "-y", "flatpak"])
    run_command(["flatpak", "remote-add", "--if-not-exists", "flathub", "https://flathub.org/repo/flathub.flatpakrepo"])
    line()      
    print("\n")      


def install_app(app_id):
    try:
        subprocess.run(["flatpak", "install", "flathub", app_id], check=True)
    except subprocess.CalledProcessError as e:
        print(f"app not found:{e}")
        sys.exit(1)

def delay():
    for _ in range(110):
        sys.stdout.write("*")
        sys.stdout.flush()
        time.sleep(0.01)

def line():
    for _ in range(60):
        sys.stdout.write("=")
        sys.stdout.flush()
        time.sleep(0.05)



def main():
    delay()
    print('''
                                                                                                    
                     <++\ ..app installation usage.. /++>                                                         |         
                                                                                                                  |
        [< .. Enter app name: (example) wps .. >]                                                                 | 
        [< .. Search results for 'wps'.. >]-------]                                                               |
        [< .. Name              Application ID             Version            Branch       Installation .. >]     |
             WPS Office        com.wps.Office             11.1.0.11719       stable       system                  |        
        [[.. use the Application ID (com.wps.Office) for installation of the app ..]]                             | 
                                                                                                                  |
                    <++ ..app running usage.. ++>                                                                 |
                                                                                                                  |
        [==[ ..use the comand : flatpak run (Application ID).. ]==]                                               |
        **NOTE:-After installation, the app is ran automatically by py-store                                      |
                -Use above command to run app in terminal                                                         |                                          
    ''')
    console.print("""       **NOTE: Application ID is Key sensitive, Enter the exact Application id to install 
                           
                **NOTE:To view all installed apps, run: flatpak list     \n""", style="red")
    delay()
    terminate = "quit"
    console.print("\nEnter quit to exit", style="blue")
    app = input("\nEnter the app name to search: ")
    if app==terminate:
        sys.exit(1)

    flatpak_installed = check_flatpak()
    if flatpak_installed:
        console.print("loading please wait...", style="yellow")
    else:
        install_flatpak()
    flatpak_search(app)
    app_id = input("\nEnter Application ID to install the app: ")
    install_app(app_id)
    run_app(app_id)

if __name__ == "__main__":
    main()
