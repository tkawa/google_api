Google Analytics
================

Configuration
-------------

```ruby
GoogleApi.configure do
  client_id "1"

  ga do
    client_id "2"
  end
end

# ----- OR -----

GoogleApi.config.client_id    = "4"
GoogleApi.config.ga.client_id = "5"
```

<table>
  <thead>
    <tr>
      <th>name</th>
      <th>example</th>
      <th>note</th>
    </tr>
  </thead>

  <tbody>
    <tr>
      <td><b>client_id</b></td>
      <td><i>123456.apps.googleusercontent.com</i></td>
      <td rowspan="3">required for oauth 2</td>
    </tr>
    <tr>
      <td><b>client_secret</b></td>
      <td><i>123456123456123456</i></td>
    </tr>
    <tr>
      <td><b>redirect_uri</b></td>
      <td><i>http://localhost/oauth2callback</i></td>
    </tr>
    <tr>
      <td><b>client_developer_email</b></td>
      <td><i>123456@developer.gserviceaccount.com</i></td>
      <td rowspan="3">required for login by cert</td>
    </tr>
    <tr>
      <td><b>client_cert_file</b></td>
      <td><i>/home/user/app/123456-privatekey.p12</i></td>
    </tr>
    <tr>
      <td><b>key_secret</b></td>
      <td><i>notasecret</i></td>
    </tr>
    <tr>
      <td colspan="3">only for ga</td>
    </tr>
    <tr>
      <td><b>cache</b></td>
      <td><i>default: </i><b>GoogleApi::Cache.new</b></td>
      <td>more information <a href="#Cache">Cache</a></td>
    </tr>
  </tbody>
</table>

<a name="Cache"></a>
Cache
-----

Cache mus have these methods:

`write(key, value, expire = 0)` - 0 for never expire<br>
`read(key)`<br>
`exists?(key)`<br>
`delete(key)`

Session
-------

There is a 3 way for starting sesssion.

### By cert file

`First you must add your developer email to google analytics profile.`

```ruby
GoogleApi::Ga::Session.login_by_cert
```

If login return false, trying login again.

```ruby
GoogleApi::Ga::Session.login_by_cert!
```

### By oauth 2

```ruby
# return uri for oauth 2 login
GoogleApi::Ga::Session.login

# after callback
# code = code key in query (params[:code])
GoogleApi::Ga::Session.login(code)
```

**In rails:**

```ruby
redirect_to(GoogleApi::Ga::Session.login)

# in page specified in redirect_uri
GoogleApi::Ga::Session.login(params[:code])
```

### By oauth 2 via line (browser needed)

This will create TCPServer. After login will be closed.

**server:** optional is localhost, must be full path!<br>
**port:** on which port the server will listen

```ruby
# default:
#   server = http://localhost/oauth2callback
#   port = 0 - get first free port
GoogleApi::Ga::Session.login_by_line(server, port)
```

Management
----------

<table>
  <thead>
    <tr>
      <th colspan="2">Account ~~~ Webproperty ~~~ Profile ~~~ Goal ~~~ Segment</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><b>all</b></td>
      <td>find all</td>
    </tr>
    <tr>
      <td><b>find(id)</b></td>
      <td>find one by id</td>
    </tr>
    <tr>
      <td><b>refresh</b></td>
      <td>refresh data</td>
    </tr>
  </tbody>
</table>

#### Account

```ruby
# Variables: id, name, created, updated
# Methods:   webproperties

GoogleApi::Ga::Account
```

#### Webproperty

```ruby
# Variables: id, name, created, updated, accountId, websiteUrl
# Methods:   account, profiles

GoogleApi::Ga::Webproperty
```

#### Profile

```ruby
# Variables: id, name, created, updated, accountId, websiteUrl, currency, timezone
# Methods:   webproperty, goals

GoogleApi::Ga::Profile
```

#### Goal

```ruby
# Variables: accountId, webPropertyId, profileId, value, active, type, goal
# Methods:   profile

GoogleApi::Ga::Goal
```

#### Segment

```ruby
# Variables: segmentId, definition

GoogleApi::Ga::Segment
```

Set default id
--------------

```ruby
GoogleApi::Ga.id(123456) # profile id
```

Data
----

First you can play on the playground: http://ga-dev-tools.appspot.com/explorer/.

```ruby
GoogleApi::Ga::Data
```

<table>
  <thead>
    <tr>
      <th>method</th>
      <th>alias</th>
      <th>description</th>
      <th>required</th>
      <th></th>
    </tr>
  </thead>

  <tbody>  
    <tr>
      <td>ids</td>
      <td>id</td>
      <td>id of profile, by default use default id (GoogleApi::Ga.id)</td>
      <td>yes (if GoogleApi::Ga.id not set)</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#ids" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>cache</td>
      <td></td>
      <td>
        for how long in minutes will be data cached,<br>
        for example: visitors count between last year and last week will not change
      </td>
      <td>no</td>
      <td></td>
    </tr>
    <tr>
      <td>start_date</td>
      <td>from</td>
      <td>
        default: Date.today<br>
        parameter: String (YYYY-MM-DD), Date, DateTime, Time, Integer (how many days add to today)
      </td>
      <td>no</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#startDate" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>end_date</td>
      <td>to</td>
      <td>same as start_date</td>
      <td>no</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#endDate" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>metrics</td>
      <td>select</td>
      <td>parameter: Array with String or Symbol, String (not compiled, <i>"ga:visitors"</i>) or Symbol (compiled, <i>:visitors</i>)</td>
      <td>yes</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#metrics" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>dimensions</td>
      <td>with</td>
      <td>same as metrics</td>
      <td>no</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#dimensions" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>sort</td>
      <td></td>
      <td>same as metrics</td>
      <td>no</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#sort" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>filter</td>
      <td>where</td>
      <td>filter data, use {(attribute operator value) & (attribute operator value) | (attribute operator value)} or String (not compiled)</td>
      <td>no</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#filter" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>segment</td>
      <td></td>
      <td>same as filter, with {} automaticly add "dynamic::"</td>
      <td>no</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#segment" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>start_index</td>
      <td>offset</td>
      <td>Integer</td>
      <td>no</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#startIndex" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>max_results</td>
      <td>limit</td>
      <td>Integer from 1 to 10 000</td>
      <td>no</td>
      <td><a href="https://developers.google.com/analytics/devguides/reporting/core/v3/reference#maxResults" target="_blank">doc</a></td>
    </tr>
    <tr>
      <td>clear</td>
      <td></td>
      <td>clear loaded data</td>
      <td>no</td>
      <td></td>
    </tr>
  </tbody>
</table>

### Fetch data

You can use one of these. Data is stored in the class.

<b>`all`</b> - `[header, rows]`<br>
<b>`rows`</b> - rows returned by google analytics<br>
<b>`header`</b> - header of data, (`["ga:day", "ga:month", "ga:visitis"]`)<br>
<b>`count`</b> - number of rows<br>
<b>`each`</b> - each as you expected, (`|data|` or `|index, data|`)
<br>
<br>

##### Clear stored data and fetch again.

clear:<br>
<b>`clear`</b><br>

clear and fetch new:<br>
<b>`all!`</b>, <b>`rows!`</b>, <b>`header!`</b>, <b>`count!`</b>, <b>`each!`</b><br><br>

If you add some parameters clear is called automaticly.

Examples
--------

**Start session:**
```ruby
# set configuration
GoogleApi.config.ga.client_cert_file = "privatekey.p12"
GoogleApi.config.ga.client_developer_email = "123456@developer.gserviceaccount.com"

# start session
GoogleApi::Ga::Session.login_by_cert!

# get profile id
id = GoogleApi::Ga::Profile.all.first.id

# set default id
GoogleApi::Ga.id(id)
```
<br>
**Count of visitors between previous month and today.**
```ruby
GoogleApi::Ga::Data.from(-30).select(:visits).rows
```
<br>
**Count of visitors between previous month and today - 2, and cache it for 30 minutes.**
```ruby
GoogleApi::Ga::Data.from(-30).to(DateTime.now - 2).select(:visits).cache(30).rows
```
<br>
**Visitors by day, month, year from Czech Republic. Browser is Firefox and Opera or Chrome**
```ruby
GoogleApi::Ga::Data.from(-30)
                   .select(:visits)
                   .with(:day, :month, :year)
                   .where{(country == "Czech Republic") & (browser == "Firefox") &
                          (browser == "Opera") | (browser == "Chrome")}
                   .sort(:year, :month, :day)
                   .rows
# OR
GoogleApi::Ga::Data.from(-30)
                   .select(:visits)
                   .with(:day, :month, :year)
                   .where("ga:country==Czech Republic;ga:browser==Firefox;ga:browser==Opera,ga:browser==Chrome")
                   .sort(:year, :month, :day)
                   .rows
```