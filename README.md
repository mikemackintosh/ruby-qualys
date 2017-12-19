[![Build Status](https://travis-ci.org/Cyberwatch/ruby-qualys.svg?branch=master)](https://travis-ci.org/Cyberwatch/ruby-qualys)
[![Coverage Status](https://coveralls.io/repos/github/Cyberwatch/ruby-qualys/badge.svg?branch=master)](https://coveralls.io/github/Cyberwatch/ruby-qualys?branch=master)

# Ruby Qualys API v2

A Ruby extension for interfacing with Qualys v2 API.

### Introduction

I had the need to pull stats and details from Qualys automatically to collect and alert on metrics. Let's face it, in 2015, email alerts just don't cut it anymore.

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-qualys', git: 'https://github.com/Cyberwatch/ruby-qualys.git'

And then execute:

    $ bundle

## Usage

Below you can find details on the configuration and usage of the Qualys API Client.

### Configuration

Before utilizing the API, you must configure it. You can configure it with a block like below, or by passing in a `Hash#` or load a yaml file.
```ruby
Qualys.configure do |config|
  config.username = @email
  config.password = @password
end
```

or configure using a `yaml` doc:

```ruby
Qualys::Config.load!("config/qualys.yaml")
```
### Login

Login before making other API calls:

```ruby
Qualys::Auth.login
```
### Getting Scans

You can easily get a list of all scans within your Qualys account by accessing the following methods:

```ruby
scans = Qualys::Scans.all
  #-> [#<Qualys::Scan:0x007fad4c4645c8 @ref="scan/refid", @title="Scan Title", @type="Scheduled", @date="2015-04-15T12:02:12Z", @duration="01:51:38", @status="Finished", @target="ip ranges", @user="managing_user">...
```

You can get more details from each scan like:

```ruby
scans = Qualys::Scans.all
puts scans.first.details
  #-> {"ip"=>"x.x.x.x", "dns"=>"mikemackintosh.com", "netbios"=>nil, "qid"=>86000, "result"=>"Server Version\tServer Banner\nnginx\tnginx", "protocol"=>"tcp", "port"=>"80", "ssl"=>"no", "fqdn"=>""}, 
  #   {"ip"=>"x.x.x.x", "dns"=>"mikemackintosh.com", "netbios"=>nil, "qid"=>86189, "result"=>"Number of web servers behind load balancer:\n2 - based on IP Identification values", "protocol"=>"tcp", "port"=>"80", "ssl"=>"no", "fqdn"=>""}, 
  #  {"ip"=>"x.x.x.x, "dns"=>"mikemackintosh.com", "netbios"=>nil, "qid"=>86001, "result"=>"Server Version\tServer Banner\nnginx\tnginx", "protocol"=>"tcp", "port"=>"443", "ssl"=>"no", "fqdn"=>""}
```


### Set the URI

If your URL differs from the default, set it using:

```ruby
Qualys::Api.base_uri = OTHER_PRODUCTION_ENDPOINT
```
### Getting vulnerabilities

You can load the vulnerability detected by qualys for the hosts scanned by a specific scan
if you don't specify any `scan_ref`, it prints all vulnerabilities detected by qualys so far for the logged user.
Here an example printing some information on the vulnerabilities for the second scan of the logged user :

```ruby
scan_ref = Qualys::Scans.all[1].ref
Qualys::Report.create(scan_ref).hosts.each{ |host|
  p "ip:#{ host.ip }"
  p "vulns : (#{ host.vulnerabilities.count })"
  host.vulnerabilities.each{ |vuln|
    p vuln.to_s
  }
}
```

Output :
```
"ip:12.34.156.89"
"vulns : (16)"
"qid_38173, SSL Certificate - Signature Verification Failed Vulnerability, severity : 2, cves: no cve"
"qid_38685, SSL Certificate - Invalid Maximum Validity Date Detected, severity : 2, cves: no cve"
"qid_38169, SSL Certificate - Self-Signed Certificate, severity : 2, cves: no cve"
"qid_38170, SSL Certificate - Subject Common Name Does Not Match Server FQDN, severity : 2, cves: no cve"
"qid_38628, SSL/TLS Server supports TLSv1.0, severity : 3, cves: no cve"
"qid_38601, SSL/TLS use of weak RC4 cipher, severity : 3, cves: CVE-2013-2566, CVE-2015-2808"
"qid_38140, SSL Server Supports Weak Encryption Vulnerability, severity : 3, cves: no cve"
"qid_38142, SSL Server Allows Anonymous Authentication Vulnerability, severity : 4, cves: no cve"
"qid_38657, Birthday attacks against TLS ciphers with 64bit block size vulnerability (Sweet32), severity : 3, cves: CVE-2016-2183"
"qid_38606, SSL Server Has SSLv3 Enabled Vulnerability, severity : 3, cves: no cve"
"qid_82003, ICMP Timestamp Request, severity : 1, cves: CVE-1999-0524"
"qid_38603, SSLv3 Padding Oracle Attack Information Disclosure Vulnerability (POODLE), severity : 3, cves: CVE-2014-3566"
"qid_11827, HTTP Security Header Not Detected, severity : 2, cves: no cve"
"qid_11827, HTTP Security Header Not Detected, severity : 2, cves: no cve"
"qid_38628, SSL/TLS Server supports TLSv1.0, severity : 3, cves: no cve"
"qid_38657, Birthday attacks against TLS ciphers with 64bit block size vulnerability (Sweet32), severity : 3, cves: CVE-2016-2183"
"ip:10.34.156.89"
"vulns : (3)"
"qid_11827, HTTP Security Header Not Detected, severity : 2, cves: no cve"
"qid_11827, HTTP Security Header Not Detected, severity : 2, cves: no cve"
"qid_38628, SSL/TLS Server supports TLSv1.0, severity : 3, cves: no cve"
```

## References

The API was built using the following documentation: 

  - https://www.qualys.com/docs/qualys-api-v2-quick-reference.pdf
  - https://www.qualys.com/docs/qualys-api-v2-user-guide.pdf?_ga=1.246313805.857253578.1427813387
