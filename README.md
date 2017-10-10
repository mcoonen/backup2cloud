# backup2cloud
``backup2cloud`` is an .sh wrapper for automated [duplicity](http://duplicity.nongnu.org/) backups.<br>
Duplicity is bandwidth-efficient backup solution that creates encrypted tar archives and can write to remote locations
using various protocols (FTP, Rsync, WebDAV, SMB, etc.).

``backup2cloud`` is developed and tested on ReadyNAS OS to create backups at [Stack](https://www.transip.nl/stack/) using the WebDAV protocol. 
The software should also run on other debian-based Linux distros. Usage of other remote storage locations and protocols 
should be possible with minimal adaptations to the configuration file.

## Preparations
### 1. Download and install duplicity
```
sudo apt-get install duplicity
```

### 2. Setup WebDAV connection (optional)
**Note:** Duplicity supports various file transfer protocols, so this step is not needed if you decide to
 configure your remote connection differently. 
 
For practicality reasons, a WebDAV folder is mounted (permanently) during boot here. It uses the ``davfs2`` 
WebDAV drivers, which is also described [here](https://www.transip.nl/vragen/756-stack-externe-back-voor-gebruiken/).
 
```
# Install the davfs2 drivers
sudo apt-get install davfs2
 
# Open the davfs secrets file with your favorite text editor
nano /etc/davfs2/secrets
 
# Add the following line to the "Credential Line" section
https://USERNAME.stackstorage.com/remote.php/webdav/path/to/stack/folder STACK_USERNAME STACK_PASSWORD
 
# Create the WebDAV mount at reboot (fstab doesn't work at ReadyNAS)
crontab -e
@reboot mount -t davfs https://USERNAME.stackstorage.com/remote.php/webdav/path/to/stack/folder /path/to/mountpoint
```
  

### 3. Clone ``backup2cloud`` repository
```
git clone https://github.com/mcoonen/backup2cloud.git
```

## Configuration


## Usage (backup)

## Usage (restore)

## Scheduling (crontab)

