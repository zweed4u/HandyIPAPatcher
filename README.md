# HandyIPAPatcher

Shell scripts to extract thin binaries from IPA, patch with modified ones and then prepare for deploying.<br>

<b>extract_thin.sh</b> - Extracts thin binaries from already decrypted app.ipa file, if needed also with all framework binaries.
<b>replace_bin.sh</b> - Packs all binaries into app.ipa, if frameworks work directory was created by <b>extract_thin.sh</b> it will replace those binaries as well. If necessary it can also strip plugins if there are some signing issues.

It's convenient tool to swiftly repack .ipa to assist with patching binaries.

![workdir](/screenshots/workdir.png?raw=true)

## Usage
1. Acquire needed decrypted IPA file. It can be downloaded from [IphoneCake](https://www.iphonecake.com) or prepared manually by using [Clutch](https://github.com/KJCracks/Clutch)
2. Copy IPA file to <b>HandyIPAPatcher</b> directory. Copy and rename it to <b>app.ipa</b>
3. Use <b>extract_thin.sh</b>
![workdir](/screenshots/extract_thin.png?raw=true)
4. This is step when you take care neccessary steps with thin binaries as you wish.
5. Repacking <b>replace_bin.sh</b>
![workdir](/screenshots/replace_bin.png?raw=true)
6. Install app to Jailbroken device or Non-Jailbroken with [Cydia Impactor](http://www.cydiaimpactor.com)

## License
MIT
