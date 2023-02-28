import subprocess
import re
import os

# Input variables; Change the value if needed 
prefix = 'gsa'
config_file = 'rclone.conf'
new_config_file = 'new_rclone.conf'


# The script is dependent on rclone v_1.61.1 
# The script may or may not work with other versions of rclone

# Color Codes
boldLightGreen = "\033[1;32m"
boldLightRed = "\033[1;31m"
boldLightBlue = "\033[1;36m"
noColor = "\033[0m"

# Check if the rclone.conf file is present and new_config_file is not present
if not os.path.isfile(config_file):
    print(f"{boldLightRed}{config_file} is not present in current directory.{noColor}")
    raise KeyboardInterrupt
elif os.path.isfile(new_config_file):
    print(f"{boldLightRed}{new_config_file} is already present in current directory.{noColor}")
    raise KeyboardInterrupt
elif os.path.isfile('rclone_lsd.txt'):
    print(f"{boldLightBlue}rclone_lsd.txt{noColor} is present in current directory from privious run. {boldLightRed}Deleting{noColor} {boldLightBlue}rclone_lsd.txt{noColor} ...")
    os.remove('rclone_lsd.txt')


# Get all the remote names and filter by prefix
output = subprocess.run(['rclone', 'listremotes', '--config', config_file], capture_output=True, text=True)
if output.returncode != 0:
    print("Error:", output.stderr)
    raise KeyboardInterrupt
remote_names = [remote.strip() for remote in output.stdout.split('\n') if remote.startswith(prefix)]

# Iterate through each remote and extract root_folder_id
for remote in remote_names:
    # Get remote config details
    output = subprocess.run(['rclone', 'config', 'show', '-vv', '--config', config_file, remote], capture_output=True, text=True)
    if output.returncode != 0:
        print(f"{boldLightRed}Error while getting config details for {remote}:{noColor}")
        print(output.stderr)
        raise KeyboardInterrupt
    with open(new_config_file, 'a') as f:
        f.write('\n' + output.stdout)

    # Get root_folder_id from rclone logs
    output = subprocess.run(['rclone', 'lsd', '-vv', '--config', config_file, remote, '--log-file', 'rclone_lsd.txt'], capture_output=True, text=True)
    if output.returncode != 0:
        print(f"{boldLightRed}Error while running rclone lsd command for {remote}:{noColor}")
        print(output.stderr)
        raise KeyboardInterrupt
    with open('rclone_lsd.txt', 'r') as f:
        logs = f.read()
    match = re.search(r"root_folder_id\s*=\s*([^\s']*)", logs)
    if match:
        drive_root_id = f'root_folder_id = "{match.group(1)}"'
        with open(new_config_file, 'a') as f:
            f.write(drive_root_id + '\n')
            
        print(f"root_folder_id added to {boldLightBlue}{remote}{noColor}")
    # Clean up
    os.remove('rclone_lsd.txt')

print(f"{boldLightGreen}Task Completed!!{noColor}")
