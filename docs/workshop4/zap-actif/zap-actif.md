# ZAP Scanning Report

ZAP by [Checkmarx](https://checkmarx.com/).


## Summary of Alerts

| Risk Level | Number of Alerts |
| --- | --- |
| High | 0 |
| Medium | 5 |
| Low | 5 |
| Informational | 9 |




## Insights

| Level | Reason | Site | Description | Statistic |
| --- | --- | --- | --- | --- |
| Low | Warning |  | ZAP warnings logged - see the zap.log file for details | 21    |
| Low | Exceeded High | http://juice-shop-zineb:3000 | Percentage of slow responses | 50 % |
| Info | Informational |  | Percentage of network failures | 1 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of responses with status code 2xx | 91 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of responses with status code 3xx | 1 % |
| Info | Exceeded Low | http://juice-shop-zineb:3000 | Percentage of responses with status code 4xx | 7 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of endpoints with content type application/javascript | 5 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of endpoints with content type application/octet-stream | 3 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of endpoints with content type image/x-icon | 1 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of endpoints with content type text/css | 1 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of endpoints with content type text/html | 86 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of endpoints with content type text/markdown | 2 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of endpoints with content type text/plain | 1 % |
| Info | Informational | http://juice-shop-zineb:3000 | Percentage of endpoints with method GET | 100 % |
| Info | Informational | http://juice-shop-zineb:3000 | Count of total endpoints | 133    |







## Alerts

| Name | Risk Level | Number of Instances |
| --- | --- | --- |
| Backup File Disclosure | Medium | 31 |
| Bypassing 403 | Medium | 6 |
| CORS Misconfiguration | Medium | Systemic |
| Content Security Policy (CSP) Header Not Set | Medium | Systemic |
| Cross-Domain Misconfiguration | Medium | Systemic |
| Cross-Origin-Embedder-Policy Header Missing or Invalid | Low | Systemic |
| Cross-Origin-Opener-Policy Header Missing or Invalid | Low | Systemic |
| Dangerous JS Functions | Low | 2 |
| Deprecated Feature Policy Header Set | Low | Systemic |
| Full Path Disclosure | Low | 6 |
| Base64 Disclosure | Informational | 11 |
| Modern Web Application | Informational | Systemic |
| Sec-Fetch-Dest Header is Missing | Informational | 4 |
| Sec-Fetch-Mode Header is Missing | Informational | 4 |
| Sec-Fetch-Site Header is Missing | Informational | 4 |
| Sec-Fetch-User Header is Missing | Informational | 4 |
| Storable and Cacheable Content | Informational | 1 |
| Storable but Non-Cacheable Content | Informational | Systemic |
| User Agent Fuzzer | Informational | Systemic |




## Alert Detail



### [ Backup File Disclosure ](https://www.zaproxy.org/docs/alerts/10095/)



##### Medium (Medium)

### Description

A backup of the file was disclosed by the web server.

* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(2&29
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (2)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(2&29/juicy_malware_linux_amd_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (2)/juicy_malware_linux_amd_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)/juicy_malware_linux_amd_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_linux_amd_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)/juicy_malware_linux_amd_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(2&29/juicy_malware_linux_arm_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (2)/juicy_malware_linux_arm_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)/juicy_malware_linux_arm_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_linux_arm_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)/juicy_malware_linux_arm_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(2&29/juicy_malware_macos_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (2)/juicy_malware_macos_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)/juicy_malware_macos_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_macos_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)/juicy_malware_macos_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(2&29/juicy_malware_windows_64.exe.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (2)/juicy_malware_windows_64.exe.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)/juicy_malware_windows_64.exe.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_windows_64.exe.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(2)/juicy_malware_windows_64.exe.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(3&29
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (3)`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(3&29/juicy_malware_linux_amd_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (3)/juicy_malware_linux_amd_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)/juicy_malware_linux_amd_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_linux_amd_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)/juicy_malware_linux_amd_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(3&29/juicy_malware_linux_arm_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (3)/juicy_malware_linux_arm_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)/juicy_malware_linux_arm_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_linux_arm_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)/juicy_malware_linux_arm_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(3&29/juicy_malware_macos_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (3)/juicy_malware_macos_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)/juicy_malware_macos_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_macos_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)/juicy_malware_macos_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy%2520(3&29/juicy_malware_windows_64.exe.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy (3)/juicy_malware_windows_64.exe.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)/juicy_malware_windows_64.exe.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_windows_64.exe.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy%20(3)/juicy_malware_windows_64.exe.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy/juicy_malware_linux_amd_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy/juicy_malware_linux_amd_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy/juicy_malware_linux_amd_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_linux_amd_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy/juicy_malware_linux_amd_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy/juicy_malware_linux_arm_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy/juicy_malware_linux_arm_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy/juicy_malware_linux_arm_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_linux_arm_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy/juicy_malware_linux_arm_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy/juicy_malware_macos_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy/juicy_malware_macos_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy/juicy_malware_macos_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_macos_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy/juicy_malware_macos_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine%2520-%2520Copy/juicy_malware_windows_64.exe.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine - Copy/juicy_malware_windows_64.exe.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy/juicy_malware_windows_64.exe.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_windows_64.exe.url] is available at [http://juice-shop-zineb:3000/ftp/quarantine%20-%20Copy/juicy_malware_windows_64.exe.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.bac
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.bac`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.bac`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.bac]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.backup
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.backup`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.backup`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.backup]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.bak
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.bak`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.bak`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.bak]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.jar
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.jar`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.jar`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.jar]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.log
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.log`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.log`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.log]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.old
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.old`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.old`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.old]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.swp
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.swp`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.swp`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.swp]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.tar
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.tar`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.tar`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.tar]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.zip
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.zip`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.zip`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.zip]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine.~bk
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine.~bk`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine.~bk`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine.~bk]`
* URL: http://juice-shop-zineb:3000/ftp/quarantinebackup
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantinebackup`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantinebackup`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantinebackup]`
* URL: http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_linux_amd_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_linux_amd_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_linux_amd_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_linux_amd_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_linux_amd_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_linux_arm_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_linux_arm_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_linux_arm_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_linux_arm_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_linux_arm_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_macos_64.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_macos_64.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_macos_64.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_macos_64.url] is available at [http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_macos_64.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_windows_64.exe.url
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_windows_64.exe.url`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_windows_64.exe.url`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine/juicy_malware_windows_64.exe.url] is available at [http://juice-shop-zineb:3000/ftp/quarantinebackup/juicy_malware_windows_64.exe.url]`
* URL: http://juice-shop-zineb:3000/ftp/quarantine~
  * Node Name: `http://juice-shop-zineb:3000/ftp/quarantine~`
  * Method: `GET`
  * Parameter: ``
  * Attack: `http://juice-shop-zineb:3000/ftp/quarantine~`
  * Evidence: ``
  * Other Info: `A backup of [http://juice-shop-zineb:3000/ftp/quarantine] is available at [http://juice-shop-zineb:3000/ftp/quarantine~]`


Instances: 31

### Solution

Do not edit files in-situ on the web server, and ensure that un-necessary files (including hidden files) are removed from the web server.

### Reference


* [ https://cwe.mitre.org/data/definitions/530.html ](https://cwe.mitre.org/data/definitions/530.html)
* [ https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/04-Review_Old_Backup_and_Unreferenced_Files_for_Sensitive_Information.html ](https://owasp.org/www-project-web-security-testing-guide/v41/4-Web_Application_Security_Testing/02-Configuration_and_Deployment_Management_Testing/04-Review_Old_Backup_and_Unreferenced_Files_for_Sensitive_Information.html)


#### CWE Id: [ 530 ](https://cwe.mitre.org/data/definitions/530.html)


#### WASC Id: 34

#### Source ID: 1

### [ Bypassing 403 ](https://www.zaproxy.org/docs/alerts/40038/)



##### Medium (Medium)

### Description

Bypassing 403 endpoints may be possible, the scan rule sent a payload that caused the response to be accessible (status code 200).

* URL: http://juice-shop-zineb:3000/%252e/ftp/coupons_2013.md.bak
  * Node Name: `http://juice-shop-zineb:3000/./ftp/coupons_2013.md.bak`
  * Method: `GET`
  * Parameter: ``
  * Attack: `/%2e/ftp/coupons_2013.md.bak`
  * Evidence: ``
  * Other Info: `http://juice-shop-zineb:3000/ftp/coupons_2013.md.bak`
* URL: http://juice-shop-zineb:3000/%252e/ftp/eastere.gg
  * Node Name: `http://juice-shop-zineb:3000/./ftp/eastere.gg`
  * Method: `GET`
  * Parameter: ``
  * Attack: `/%2e/ftp/eastere.gg`
  * Evidence: ``
  * Other Info: `http://juice-shop-zineb:3000/ftp/eastere.gg`
* URL: http://juice-shop-zineb:3000/%252e/ftp/encrypt.pyc
  * Node Name: `http://juice-shop-zineb:3000/./ftp/encrypt.pyc`
  * Method: `GET`
  * Parameter: ``
  * Attack: `/%2e/ftp/encrypt.pyc`
  * Evidence: ``
  * Other Info: `http://juice-shop-zineb:3000/ftp/encrypt.pyc`
* URL: http://juice-shop-zineb:3000/%252e/ftp/package-lock.json.bak
  * Node Name: `http://juice-shop-zineb:3000/./ftp/package-lock.json.bak`
  * Method: `GET`
  * Parameter: ``
  * Attack: `/%2e/ftp/package-lock.json.bak`
  * Evidence: ``
  * Other Info: `http://juice-shop-zineb:3000/ftp/package-lock.json.bak`
* URL: http://juice-shop-zineb:3000/%252e/ftp/package.json.bak
  * Node Name: `http://juice-shop-zineb:3000/./ftp/package.json.bak`
  * Method: `GET`
  * Parameter: ``
  * Attack: `/%2e/ftp/package.json.bak`
  * Evidence: ``
  * Other Info: `http://juice-shop-zineb:3000/ftp/package.json.bak`
* URL: http://juice-shop-zineb:3000/%252e/ftp/suspicious_errors.yml
  * Node Name: `http://juice-shop-zineb:3000/./ftp/suspicious_errors.yml`
  * Method: `GET`
  * Parameter: ``
  * Attack: `/%2e/ftp/suspicious_errors.yml`
  * Evidence: ``
  * Other Info: `http://juice-shop-zineb:3000/ftp/suspicious_errors.yml`


Instances: 6

### Solution



### Reference


* [ https://www.acunetix.com/blog/articles/a-fresh-look-on-reverse-proxy-related-attacks/ ](https://www.acunetix.com/blog/articles/a-fresh-look-on-reverse-proxy-related-attacks/)
* [ https://i.blackhat.com/us-18/Wed-August-8/us-18-Orange-Tsai-Breaking-Parser-Logic-Take-Your-Path-Normalization-Off-And-Pop-0days-Out-2.pdf ](https://i.blackhat.com/us-18/Wed-August-8/us-18-Orange-Tsai-Breaking-Parser-Logic-Take-Your-Path-Normalization-Off-And-Pop-0days-Out-2.pdf)
* [ https://seclists.org/fulldisclosure/2011/Oct/273 ](https://seclists.org/fulldisclosure/2011/Oct/273)


#### CWE Id: [ 348 ](https://cwe.mitre.org/data/definitions/348.html)


#### Source ID: 1

### [ CORS Misconfiguration ](https://www.zaproxy.org/docs/alerts/40040/)



##### Medium (High)

### Description

This CORS misconfiguration could allow an attacker to perform AJAX queries to the vulnerable website from a malicious page loaded by the victim's user agent.
In order to perform authenticated AJAX queries, the server must specify the header "Access-Control-Allow-Credentials: true" and the "Access-Control-Allow-Origin" header must be set to null or the malicious page's domain. Even if this misconfiguration doesn't allow authenticated AJAX requests, unauthenticated sensitive content can still be accessed (e.g intranet websites).
A malicious page can belong to a malicious website but also a trusted website with flaws (e.g XSS, support of HTTP without TLS allowing code injection through MITM, etc).

* URL: http://juice-shop-zineb:3000
  * Node Name: `http://juice-shop-zineb:3000`
  * Method: `GET`
  * Parameter: ``
  * Attack: `origin: http://KI04RvKb.com`
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: ``
  * Attack: `origin: http://KI04RvKb.com`
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/assets
  * Node Name: `http://juice-shop-zineb:3000/assets`
  * Method: `GET`
  * Parameter: ``
  * Attack: `origin: http://KI04RvKb.com`
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

If a web resource contains sensitive information, the origin should be properly specified in the Access-Control-Allow-Origin header. Only trusted websites needing this resource should be specified in this header, with the most secured protocol supported.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CORS ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CORS)
* [ https://portswigger.net/web-security/cors ](https://portswigger.net/web-security/cors)


#### CWE Id: [ 942 ](https://cwe.mitre.org/data/definitions/942.html)


#### WASC Id: 14

#### Source ID: 1

### [ Content Security Policy (CSP) Header Not Set ](https://www.zaproxy.org/docs/alerts/10038/)



##### Medium (High)

### Description

Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks, including Cross Site Scripting (XSS) and data injection attacks. These attacks are used for everything from data theft to site defacement or distribution of malware. CSP provides a set of standard HTTP headers that allow website owners to declare approved sources of content that browsers should be allowed to load on that page — covered types are JavaScript, CSS, HTML frames, fonts, images and embeddable objects such as Java applets, ActiveX, audio and video files.

* URL: http://juice-shop-zineb:3000
  * Node Name: `http://juice-shop-zineb:3000`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp
  * Node Name: `http://juice-shop-zineb:3000/ftp`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp/eastere.gg
  * Node Name: `http://juice-shop-zineb:3000/ftp/eastere.gg`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/sitemap.xml
  * Node Name: `http://juice-shop-zineb:3000/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that your web server, application server, load balancer, etc. is configured to set the Content-Security-Policy header.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/CSP)
* [ https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html ](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)
* [ https://www.w3.org/TR/CSP/ ](https://www.w3.org/TR/CSP/)
* [ https://w3c.github.io/webappsec-csp/ ](https://w3c.github.io/webappsec-csp/)
* [ https://web.dev/articles/csp ](https://web.dev/articles/csp)
* [ https://caniuse.com/#feat=contentsecuritypolicy ](https://caniuse.com/#feat=contentsecuritypolicy)
* [ https://content-security-policy.com/ ](https://content-security-policy.com/)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 15

#### Source ID: 3

### [ Cross-Domain Misconfiguration ](https://www.zaproxy.org/docs/alerts/10098/)



##### Medium (Medium)

### Description

Web browser data loading may be possible, due to a Cross Origin Resource Sharing (CORS) misconfiguration on the web server.

* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juice-shop-zineb:3000/chunk-DBPdFzgj.js
  * Node Name: `http://juice-shop-zineb:3000/chunk-DBPdFzgj.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juice-shop-zineb:3000/robots.txt
  * Node Name: `http://juice-shop-zineb:3000/robots.txt`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js
  * Node Name: `http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`
* URL: http://juice-shop-zineb:3000/styles.css
  * Node Name: `http://juice-shop-zineb:3000/styles.css`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Access-Control-Allow-Origin: *`
  * Other Info: `The CORS misconfiguration on the web server permits cross-domain read requests from arbitrary third party domains, using unauthenticated APIs on this domain. Web browser implementations do not permit arbitrary third parties to read the response from authenticated APIs, however. This reduces the risk somewhat. This misconfiguration could be used by an attacker to access data that is available in an unauthenticated manner, but which uses some other form of security, such as IP address white-listing.`

Instances: Systemic


### Solution

Ensure that sensitive data is not available in an unauthenticated manner (using IP address white-listing, for instance).
Configure the "Access-Control-Allow-Origin" HTTP header to a more restrictive set of domains, or remove all CORS headers entirely, to allow the web browser to enforce the Same Origin Policy (SOP) in a more restrictive manner.

### Reference


* [ https://vulncat.fortify.com/en/detail?category=HTML5&subcategory=Overly%20Permissive%20CORS%20Policy ](https://vulncat.fortify.com/en/detail?category=HTML5&subcategory=Overly%20Permissive%20CORS%20Policy)


#### CWE Id: [ 264 ](https://cwe.mitre.org/data/definitions/264.html)


#### WASC Id: 14

#### Source ID: 3

### [ Cross-Origin-Embedder-Policy Header Missing or Invalid ](https://www.zaproxy.org/docs/alerts/90004/)



##### Low (Medium)

### Description

Cross-Origin-Embedder-Policy header is a response header that prevents a document from loading any cross-origin resources that don't explicitly grant the document permission (using CORP or CORS).

* URL: http://juice-shop-zineb:3000
  * Node Name: `http://juice-shop-zineb:3000`
  * Method: `GET`
  * Parameter: `Cross-Origin-Embedder-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: `Cross-Origin-Embedder-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp
  * Node Name: `http://juice-shop-zineb:3000/ftp`
  * Method: `GET`
  * Parameter: `Cross-Origin-Embedder-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:421:3`
  * Method: `GET`
  * Parameter: `Cross-Origin-Embedder-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/sitemap.xml
  * Node Name: `http://juice-shop-zineb:3000/sitemap.xml`
  * Method: `GET`
  * Parameter: `Cross-Origin-Embedder-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that the application/web server sets the Cross-Origin-Embedder-Policy header appropriately, and that it sets the Cross-Origin-Embedder-Policy header to 'require-corp' for documents.
If possible, ensure that the end user uses a standards-compliant and modern web browser that supports the Cross-Origin-Embedder-Policy header (https://caniuse.com/mdn-http_headers_cross-origin-embedder-policy).

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cross-Origin-Embedder-Policy ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cross-Origin-Embedder-Policy)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 14

#### Source ID: 3

### [ Cross-Origin-Opener-Policy Header Missing or Invalid ](https://www.zaproxy.org/docs/alerts/90004/)



##### Low (Medium)

### Description

Cross-Origin-Opener-Policy header is a response header that allows a site to control if others included documents share the same browsing context. Sharing the same browsing context with untrusted documents might lead to data leak.

* URL: http://juice-shop-zineb:3000
  * Node Name: `http://juice-shop-zineb:3000`
  * Method: `GET`
  * Parameter: `Cross-Origin-Opener-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: `Cross-Origin-Opener-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp
  * Node Name: `http://juice-shop-zineb:3000/ftp`
  * Method: `GET`
  * Parameter: `Cross-Origin-Opener-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:421:3`
  * Method: `GET`
  * Parameter: `Cross-Origin-Opener-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/sitemap.xml
  * Node Name: `http://juice-shop-zineb:3000/sitemap.xml`
  * Method: `GET`
  * Parameter: `Cross-Origin-Opener-Policy`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that the application/web server sets the Cross-Origin-Opener-Policy header appropriately, and that it sets the Cross-Origin-Opener-Policy header to 'same-origin' for documents.
'same-origin-allow-popups' is considered as less secured and should be avoided.
If possible, ensure that the end user uses a standards-compliant and modern web browser that supports the Cross-Origin-Opener-Policy header (https://caniuse.com/mdn-http_headers_cross-origin-opener-policy).

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cross-Origin-Opener-Policy ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Cross-Origin-Opener-Policy)


#### CWE Id: [ 693 ](https://cwe.mitre.org/data/definitions/693.html)


#### WASC Id: 14

#### Source ID: 3

### [ Dangerous JS Functions ](https://www.zaproxy.org/docs/alerts/10110/)



##### Low (Low)

### Description

A dangerous JS function seems to be in use that would leave the site vulnerable.

* URL: http://juice-shop-zineb:3000/chunk-Cv2YgWUq.js
  * Node Name: `http://juice-shop-zineb:3000/chunk-Cv2YgWUq.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `bypassSecurityTrustHtml(`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/main.js
  * Node Name: `http://juice-shop-zineb:3000/main.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `bypassSecurityTrustHtml(`
  * Other Info: ``


Instances: 2

### Solution

See the references for security advice on the use of these functions.

### Reference


* [ https://v17.angular.io/guide/security ](https://v17.angular.io/guide/security)


#### CWE Id: [ 749 ](https://cwe.mitre.org/data/definitions/749.html)


#### Source ID: 3

### [ Deprecated Feature Policy Header Set ](https://www.zaproxy.org/docs/alerts/10063/)



##### Low (Medium)

### Description

The header has now been renamed to Permissions-Policy.

* URL: http://juice-shop-zineb:3000
  * Node Name: `http://juice-shop-zineb:3000`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Feature-Policy`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Feature-Policy`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/chunk-DBPdFzgj.js
  * Node Name: `http://juice-shop-zineb:3000/chunk-DBPdFzgj.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Feature-Policy`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js
  * Node Name: `http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Feature-Policy`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/sitemap.xml
  * Node Name: `http://juice-shop-zineb:3000/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `Feature-Policy`
  * Other Info: ``

Instances: Systemic


### Solution

Ensure that your web server, application server, load balancer, etc. is configured to set the Permissions-Policy header instead of the Feature-Policy header.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Permissions-Policy ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Permissions-Policy)
* [ https://scotthelme.co.uk/goodbye-feature-policy-and-hello-permissions-policy/ ](https://scotthelme.co.uk/goodbye-feature-policy-and-hello-permissions-policy/)


#### CWE Id: [ 16 ](https://cwe.mitre.org/data/definitions/16.html)


#### WASC Id: 15

#### Source ID: 3

### [ Full Path Disclosure ](https://www.zaproxy.org/docs/alerts/110009/)



##### Low (Low)

### Description

The full path of files which might be sensitive has been exposed to the client.

* URL: http://juice-shop-zineb:3000/ftp/coupons_2013.md.bak
  * Node Name: `http://juice-shop-zineb:3000/ftp/coupons_2013.md.bak`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/lib/`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp/eastere.gg
  * Node Name: `http://juice-shop-zineb:3000/ftp/eastere.gg`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/lib/`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp/encrypt.pyc
  * Node Name: `http://juice-shop-zineb:3000/ftp/encrypt.pyc`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/lib/`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp/package-lock.json.bak
  * Node Name: `http://juice-shop-zineb:3000/ftp/package-lock.json.bak`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/lib/`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp/package.json.bak
  * Node Name: `http://juice-shop-zineb:3000/ftp/package.json.bak`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/lib/`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/ftp/suspicious_errors.yml
  * Node Name: `http://juice-shop-zineb:3000/ftp/suspicious_errors.yml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/lib/`
  * Other Info: ``


Instances: 6

### Solution

Disable directory browsing in your web server. Refer to the web server documentation.

### Reference


* [ https://owasp.org/www-community/attacks/Full_Path_Disclosure ](https://owasp.org/www-community/attacks/Full_Path_Disclosure)


#### CWE Id: [ 209 ](https://cwe.mitre.org/data/definitions/209.html)


#### WASC Id: 13

#### Source ID: 3

### [ Base64 Disclosure ](https://www.zaproxy.org/docs/alerts/10094/)



##### Informational (Medium)

### Description

Base64 encoded data was disclosed by the application/web server. Note: in the interests of performance not all base64 strings in the response were analyzed individually, the entire response should be looked at by the analyst/security team/developer(s).

* URL: http://juice-shop-zineb:3000
  * Node Name: `http://juice-shop-zineb:3000`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `com/s/vt323/v18/pxiKyp0ihIEF2isQFJXGdg`
  * Other Info: `r������m��_?��ʝ"���+��v`
* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `com/s/vt323/v18/pxiKyp0ihIEF2isQFJXGdg`
  * Other Info: `r������m��_?��ʝ"���+��v`
* URL: http://juice-shop-zineb:3000/ftp
  * Node Name: `http://juice-shop-zineb:3000/ftp`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABGdBTUEAALGPC/xhBQAAAWtQTFRFAAAA/PPQ9Nhc2q402qQ12qs2/PTX2pg12p81+/LM89NE9dto2q82+/fp2rM22qY39d6U+/bo2qo2/frx/vz32q812qs12qE279SU8c4w9NZP+/LK//367s9y7s925cp0/vzw9t92//342po2/vz25s1579B6+OSO2bQ0/v799NyT8tE79dld8Msm+OrC/vzx79KA2IYs7s6I9d6R4cJe9+OF/PLI/fry79OF/v30//328tWB89RJ8c9p8c0u9eCf//7+9txs6sts5Mdr+++5+u2z/vrv+/fq6cFz8dBs8tA57cpq+OaU9uGs27Y8//799NdX/PbY9uB89unJ//z14sNf+emh+emk+vDc+uys9+OL8dJy89NH+eic8tN5+OaV+OWR9N2n9dtl9t529+KF9+GB9Nue9NdU8tR/9t5y89qW9dpj89iO89eG/vvu2pQ12Y4z/vzy2Ict/vvv48dr/vzz4sNg///+2Igty3PqwQAAAAF0Uk5TAEDm2GYAAACtSURBVBjTY2AgA2iYlJWVhfohBPg0yx38y92dS0pKVOVBAqIi6sb2vsWWpfrFeTI8QAEhYQEta28nCwM1OVleZqCAmKCEkUdwYWmhQnFeOStQgL9cySqkNNDHVJGbiY0FKCCuYuYSGRsV5KgjxcXIARRQNncNj09JTgqw0ZbkZAcK5LuFJaRmZqfHeNnpSucDBQoiEtOycnIz4qI9bfUKQA6pKKqAgqIKQyK8BgAZ5yfODmnHrQAAAABJRU5ErkJggg==`
  * Other Info: `�PNG

   IHDR         (-S   gAMA  ���a  kPLTE   �����\ڮ4ڤ5ګ6���ژ5ڟ5�����D��hگ6���ڳ6ڦ7�ޔ���ڪ6������گ5ګ5ڡ6�Ԕ��0��O��������r��v��t�����v���ښ6�����y��z��ٴ4����ܓ��;��]��&�������Ҁ؆,�Έ�ޑ��^���������Ӆ�������Ձ��I��i��.��������l��l��k������������s��l��9��j����۶<�����W�����|��������_�������������r��G����y�����ݧ��e��v�����۞��T����r�ږ��c�؎�׆���ڔ5َ3���؇-�����k�����`���؈-�s��   tRNS @��f   �IDAT�c` h������!�4���ݝKJJT�A�"����Ŗ���y2<@!a-ko'59Y^f������Gpai�Bq^9+P��\�*�4��T����( �b��#���P6w�OIN
�і�d
仅%�ff��x��J�
"Ӳrr3�=m�
@�(����
C"� �'�iǭ    IEND�B`�`
* URL: http://juice-shop-zineb:3000/juice-shop/build/routes/assets/public/favicon_js.ico
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/build/routes/assets/public/favicon_js.ico`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `com/s/vt323/v18/pxiKyp0ihIEF2isQFJXGdg`
  * Other Info: `r������m��_?��ʝ"���+��v`
* URL: http://juice-shop-zineb:3000/juice-shop/build/routes/fileServer.js:52:13
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/build/routes/fileServer.js:52:13`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `com/s/vt323/v18/pxiKyp0ihIEF2isQFJXGdg`
  * Other Info: `r������m��_?��ʝ"���+��v`
* URL: http://juice-shop-zineb:3000/juice-shop/build/routes/fileServer.js:68:18
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/build/routes/fileServer.js:68:18`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `com/s/vt323/v18/pxiKyp0ihIEF2isQFJXGdg`
  * Other Info: `r������m��_?��ʝ"���+��v`
* URL: http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:328:13
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:328:13`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `com/s/vt323/v18/pxiKyp0ihIEF2isQFJXGdg`
  * Other Info: `r������m��_?��ʝ"���+��v`
* URL: http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:421:3`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `com/s/vt323/v18/pxiKyp0ihIEF2isQFJXGdg`
  * Other Info: `r������m��_?��ʝ"���+��v`
* URL: http://juice-shop-zineb:3000/main.js
  * Node Name: `http://juice-shop-zineb:3000/main.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ`
  * Other Info: `�]�㞻�֛qן���Y�����ۯ�� �Q� ��0ӏA�QU�a`
* URL: http://juice-shop-zineb:3000/sitemap.xml
  * Node Name: `http://juice-shop-zineb:3000/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `com/s/vt323/v18/pxiKyp0ihIEF2isQFJXGdg`
  * Other Info: `r������m��_?��ʝ"���+��v`
* URL: http://juice-shop-zineb:3000/styles.css
  * Node Name: `http://juice-shop-zineb:3000/styles.css`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `/media/material-icons-outlined-7BWLPMFK`
  * Other Info: `�g����j׫��~��'��.�X�y߻b�0R`


Instances: 11

### Solution

Manually confirm that the Base64 data does not leak sensitive information, and that the data cannot be aggregated/used to exploit other vulnerabilities.

### Reference


* [ https://projects.webappsec.org/w/page/13246936/Information%20Leakage ](https://projects.webappsec.org/w/page/13246936/Information%20Leakage)


#### CWE Id: [ 319 ](https://cwe.mitre.org/data/definitions/319.html)


#### WASC Id: 13

#### Source ID: 3

### [ Modern Web Application ](https://www.zaproxy.org/docs/alerts/10109/)



##### Informational (Medium)

### Description

The application appears to be a modern web application. If you need to explore it automatically then the Client Spider may well be more effective than the standard one.

* URL: http://juice-shop-zineb:3000
  * Node Name: `http://juice-shop-zineb:3000`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script>
    window.addEventListener("load", function(){
      window.cookieconsent.initialise({
        "palette": {
          "popup": { "background": "var(--theme-primary)", "text": "var(--theme-text)" },
          "button": { "background": "var(--theme-accent)", "text": "var(--theme-text)" }
        },
        "theme": "classic",
        "position": "bottom-right",
        "content": { "message": "This website uses fruit cookies to ensure you get the juiciest tracking experience.", "dismiss": "Me want it!", "link": "But me wait!", "href": "https://www.youtube.com/watch?v=9PnbKL3wuH4" }
      })});
  </script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script>
    window.addEventListener("load", function(){
      window.cookieconsent.initialise({
        "palette": {
          "popup": { "background": "var(--theme-primary)", "text": "var(--theme-text)" },
          "button": { "background": "var(--theme-accent)", "text": "var(--theme-text)" }
        },
        "theme": "classic",
        "position": "bottom-right",
        "content": { "message": "This website uses fruit cookies to ensure you get the juiciest tracking experience.", "dismiss": "Me want it!", "link": "But me wait!", "href": "https://www.youtube.com/watch?v=9PnbKL3wuH4" }
      })});
  </script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juice-shop-zineb:3000/juice-shop/build/routes/fileServer.js:52:13
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/build/routes/fileServer.js:52:13`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script>
    window.addEventListener("load", function(){
      window.cookieconsent.initialise({
        "palette": {
          "popup": { "background": "var(--theme-primary)", "text": "var(--theme-text)" },
          "button": { "background": "var(--theme-accent)", "text": "var(--theme-text)" }
        },
        "theme": "classic",
        "position": "bottom-right",
        "content": { "message": "This website uses fruit cookies to ensure you get the juiciest tracking experience.", "dismiss": "Me want it!", "link": "But me wait!", "href": "https://www.youtube.com/watch?v=9PnbKL3wuH4" }
      })});
  </script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:421:3
  * Node Name: `http://juice-shop-zineb:3000/juice-shop/node_modules/express/lib/router/index.js:421:3`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script>
    window.addEventListener("load", function(){
      window.cookieconsent.initialise({
        "palette": {
          "popup": { "background": "var(--theme-primary)", "text": "var(--theme-text)" },
          "button": { "background": "var(--theme-accent)", "text": "var(--theme-text)" }
        },
        "theme": "classic",
        "position": "bottom-right",
        "content": { "message": "This website uses fruit cookies to ensure you get the juiciest tracking experience.", "dismiss": "Me want it!", "link": "But me wait!", "href": "https://www.youtube.com/watch?v=9PnbKL3wuH4" }
      })});
  </script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`
* URL: http://juice-shop-zineb:3000/sitemap.xml
  * Node Name: `http://juice-shop-zineb:3000/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `<script>
    window.addEventListener("load", function(){
      window.cookieconsent.initialise({
        "palette": {
          "popup": { "background": "var(--theme-primary)", "text": "var(--theme-text)" },
          "button": { "background": "var(--theme-accent)", "text": "var(--theme-text)" }
        },
        "theme": "classic",
        "position": "bottom-right",
        "content": { "message": "This website uses fruit cookies to ensure you get the juiciest tracking experience.", "dismiss": "Me want it!", "link": "But me wait!", "href": "https://www.youtube.com/watch?v=9PnbKL3wuH4" }
      })});
  </script>`
  * Other Info: `No links have been found while there are scripts, which is an indication that this is a modern web application.`

Instances: Systemic


### Solution

This is an informational alert and so no changes are required.

### Reference




#### Source ID: 3

### [ Sec-Fetch-Dest Header is Missing ](https://www.zaproxy.org/docs/alerts/90005/)



##### Informational (High)

### Description

Specifies how and where the data would be used. For instance, if the value is audio, then the requested resource must be audio data and not any other type of resource.

* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Dest`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/chunk-DBPdFzgj.js
  * Node Name: `http://juice-shop-zineb:3000/chunk-DBPdFzgj.js`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Dest`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/robots.txt
  * Node Name: `http://juice-shop-zineb:3000/robots.txt`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Dest`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js
  * Node Name: `http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Dest`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``


Instances: 4

### Solution

Ensure that Sec-Fetch-Dest header is included in request headers.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Dest ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Dest)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Sec-Fetch-Mode Header is Missing ](https://www.zaproxy.org/docs/alerts/90005/)



##### Informational (High)

### Description

Allows to differentiate between requests for navigating between HTML pages and requests for loading resources like images, audio etc.

* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Mode`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/chunk-DBPdFzgj.js
  * Node Name: `http://juice-shop-zineb:3000/chunk-DBPdFzgj.js`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Mode`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/robots.txt
  * Node Name: `http://juice-shop-zineb:3000/robots.txt`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Mode`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js
  * Node Name: `http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Mode`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``


Instances: 4

### Solution

Ensure that Sec-Fetch-Mode header is included in request headers.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Mode ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Mode)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Sec-Fetch-Site Header is Missing ](https://www.zaproxy.org/docs/alerts/90005/)



##### Informational (High)

### Description

Specifies the relationship between request initiator's origin and target's origin.

* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Site`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/chunk-DBPdFzgj.js
  * Node Name: `http://juice-shop-zineb:3000/chunk-DBPdFzgj.js`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Site`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/robots.txt
  * Node Name: `http://juice-shop-zineb:3000/robots.txt`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Site`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js
  * Node Name: `http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js`
  * Method: `GET`
  * Parameter: `Sec-Fetch-Site`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``


Instances: 4

### Solution

Ensure that Sec-Fetch-Site header is included in request headers.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Site ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-Site)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Sec-Fetch-User Header is Missing ](https://www.zaproxy.org/docs/alerts/90005/)



##### Informational (High)

### Description

Specifies if a navigation request was initiated by a user.

* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: `Sec-Fetch-User`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/chunk-DBPdFzgj.js
  * Node Name: `http://juice-shop-zineb:3000/chunk-DBPdFzgj.js`
  * Method: `GET`
  * Parameter: `Sec-Fetch-User`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/robots.txt
  * Node Name: `http://juice-shop-zineb:3000/robots.txt`
  * Method: `GET`
  * Parameter: `Sec-Fetch-User`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js
  * Node Name: `http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js`
  * Method: `GET`
  * Parameter: `Sec-Fetch-User`
  * Attack: ``
  * Evidence: ``
  * Other Info: ``


Instances: 4

### Solution

Ensure that Sec-Fetch-User header is included in user initiated requests.

### Reference


* [ https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-User ](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Sec-Fetch-User)


#### CWE Id: [ 352 ](https://cwe.mitre.org/data/definitions/352.html)


#### WASC Id: 9

#### Source ID: 3

### [ Storable and Cacheable Content ](https://www.zaproxy.org/docs/alerts/10049/)



##### Informational (Medium)

### Description

The response contents are storable by caching components such as proxy servers, and may be retrieved directly from the cache, rather than from the origin server by the caching servers, in response to similar requests from other users. If the response data is sensitive, personal or user-specific, this may result in sensitive information being leaked. In some cases, this may even result in a user gaining complete control of the session of another user, depending on the configuration of the caching components in use in their environment. This is primarily an issue where "shared" caching servers such as "proxy" caches are configured on the local network. This configuration is typically found in corporate or educational environments, for instance.

* URL: http://juice-shop-zineb:3000/robots.txt
  * Node Name: `http://juice-shop-zineb:3000/robots.txt`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``
  * Other Info: `In the absence of an explicitly specified caching lifetime directive in the response, a liberal lifetime heuristic of 1 year was assumed. This is permitted by rfc7234.`


Instances: 1

### Solution

Validate that the response does not contain sensitive, personal or user-specific information. If it does, consider the use of the following HTTP response headers, to limit, or prevent the content being stored and retrieved from the cache by another user:
Cache-Control: no-cache, no-store, must-revalidate, private
Pragma: no-cache
Expires: 0
This configuration directs both HTTP 1.0 and HTTP 1.1 compliant caching servers to not store the response, and to not retrieve the response (without validation) from the cache, in response to a similar request.

### Reference


* [ https://datatracker.ietf.org/doc/html/rfc7234 ](https://datatracker.ietf.org/doc/html/rfc7234)
* [ https://datatracker.ietf.org/doc/html/rfc7231 ](https://datatracker.ietf.org/doc/html/rfc7231)
* [ https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html ](https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html)


#### CWE Id: [ 524 ](https://cwe.mitre.org/data/definitions/524.html)


#### WASC Id: 13

#### Source ID: 3

### [ Storable but Non-Cacheable Content ](https://www.zaproxy.org/docs/alerts/10049/)



##### Informational (Medium)

### Description

The response contents are storable by caching components such as proxy servers, but will not be retrieved directly from the cache, without validating the request upstream, in response to similar requests from other users.

* URL: http://juice-shop-zineb:3000/
  * Node Name: `http://juice-shop-zineb:3000/`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `max-age=0`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/chunk-DBPdFzgj.js
  * Node Name: `http://juice-shop-zineb:3000/chunk-DBPdFzgj.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `max-age=0`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js
  * Node Name: `http://juice-shop-zineb:3000/rolldown-runtime-BoHGiXSq.js`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `max-age=0`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/sitemap.xml
  * Node Name: `http://juice-shop-zineb:3000/sitemap.xml`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `max-age=0`
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/styles.css
  * Node Name: `http://juice-shop-zineb:3000/styles.css`
  * Method: `GET`
  * Parameter: ``
  * Attack: ``
  * Evidence: `max-age=0`
  * Other Info: ``

Instances: Systemic


### Solution



### Reference


* [ https://datatracker.ietf.org/doc/html/rfc7234 ](https://datatracker.ietf.org/doc/html/rfc7234)
* [ https://datatracker.ietf.org/doc/html/rfc7231 ](https://datatracker.ietf.org/doc/html/rfc7231)
* [ https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html ](https://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html)


#### CWE Id: [ 524 ](https://cwe.mitre.org/data/definitions/524.html)


#### WASC Id: 13

#### Source ID: 3

### [ User Agent Fuzzer ](https://www.zaproxy.org/docs/alerts/10104/)



##### Informational (Medium)

### Description

Check for differences in response based on fuzzed User Agent (eg. mobile sites, access as a Search Engine Crawler). Compares the response statuscode and the hashcode of the response body with the original response.

* URL: http://juice-shop-zineb:3000/assets
  * Node Name: `http://juice-shop-zineb:3000/assets`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/assets
  * Node Name: `http://juice-shop-zineb:3000/assets`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)`
  * Evidence: ``
  * Other Info: ``
* URL: http://juice-shop-zineb:3000/assets/public
  * Node Name: `http://juice-shop-zineb:3000/assets/public`
  * Method: `GET`
  * Parameter: `Header User-Agent`
  * Attack: `Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1)`
  * Evidence: ``
  * Other Info: ``

Instances: Systemic


### Solution



### Reference


* [ https://owasp.org/www-project-web-security-testing-guide/ ](https://owasp.org/www-project-web-security-testing-guide/)



#### Source ID: 1


