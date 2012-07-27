# Requirements
request = require 'request'
jquery = require 'jquery'

class Fetcher
    host: "http://ichart.finance.yahoo.com"
    path: "/table.csv"
    buildParams: (symbol, startDate, endDate) ->
        [a,b,c] = [startDate.getMonth(), startDate.getDay(), startDate.getFullYear()]
        [d,e,f] = [endDate.getMonth(), endDate.getDay(), endDate.getFullYear()]
        {s:symbol, a:a, b:b, c:c, d:d, e:e, f:f, g:'d', ignore:'.csv'}
    buildUrl: (symbol, startDate, endDate) ->
        qs = jquery.param this.buildParams symbol, startDate, endDate
        this.host + this.path + "?" + qs
    fetch: (symbol, startDate, endDate, parseBody) ->
        url = this.buildUrl symbol, startDate, endDate
        request url, (err, resp, body) -> parseBody(body)


fetcher = new Fetcher()
symbol = 'crm'
startDate = new Date "2012/01/01"
endDate = new Date
fetcher.fetch symbol, startDate, endDate, (x) -> console.log x

#url = host + path + "?" + jquery.param params

#console.log url
#request url, (err, resp, body) -> console.log body


# Request url,
#    (error, response, body) ->
#        console.log response
#        console.log body

# class DataFeed
#     computeUrl = (symbol, startDate, endDate) ->
#         "http://ichart.finance.yahoo.com/table.csv?"s=" + symbol + "&d=" + endDate.getMonth + &e=20&f=2012&g=d&a=5&b=23&c=2004&ignore=.csv"
#

# url = (symbol, startDate, endDate) ->
#     "/table.csv?s=" + symbol
#
# options =
#     host: ichart.finance.yahoo.com
#     port: 80
#     path: /table.csv
#
#
#
# http:// ichart.finance.yahoo.com/table.csv?s=CRM&d=6&e=20&f=2012&g=d&a=5&b=23&c=2004&ignore=.csv
#
# #
# http://finance.yahoo.com/q/hp?s=IBM&a=00&b=2&c=1800&d=04&e=8&f=2005&g=d&z=66&y=66
#
#   * s - ticker symbol
#   * a - start month
#   * b - start day
#   * c - start year
#   * d - end month
#   * e - end day
#   * f - end year
#   * g - resolution (e.g. 'd' is daily, 'w' is weekly, 'm' is monthly)
#   * y is the offset (cursor) from the start date
#   * z is the number of results to return starting at the cursor (66
#     maximum, apparently)
#
# Note alternate url:
# http://table.finance.yahoo.com/d?a=1&b=1&c=1800&d=3&e=1&f=2006&s=yhoo&y=200&g=d
#
# Example for CSV output:
#
# http://ichart.finance.yahoo.com/table.csv?s=IBM&a=00&b=2&c=1800&d=04&e=8&f=2005&g=d&ignore=.csv
#
# (historically could use table.finance.yahoo.com as well)
#
# Note that Yahoo implements month numbering with Jan=0 and Dec=11.
#
# For CSV output, date ranges are unlimited; the output is adjusted and
# does not include any split or dividend notices.
#
# URL for splits and dividends:
#
# These are either extracted from within the historical quote results
# (non_quote_row()) or found directly:
#
# http://finance.yahoo.com/q/hp?s=IBM&a=00&b=2&c=1800&d=04&e=8&f=2005&g=v
# http://table.finance.yahoo.com/table.csv?s=IBM&a=00&b=2&c=1800&d=04&e=8&f=2005&g=v&ignore=.csv
#
# Example URL for weekly:
#
# http://finance.yahoo.com/q/hp?s=IBM&a=00&b=2&c=1962&d=01&e=27&f=2006&g=w
#
# Example URL for monthly:
#
# http://finance.yahoo.com/q/hp?s=IBM&a=00&b=2&c=1962&d=01&e=27&f=2006&g=m