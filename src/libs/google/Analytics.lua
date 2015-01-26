-----------------------------------------------------------------------------------------
-- Project: Google Analytics for Corona
--
-- Date: May 8, 2013
--
-- Version: 1.0
--
-- File name : Analytics.lua
--
-- Author: Chris Dugne @ Uralys - www.uralys.com
--
----------------------------------------------------------------------------------------------------

module(..., package.seeall)

----------------------------------------------------------------------------------------------------

ANALYTICS_URL = "http://www.google-analytics.com/collect"

----------------------------------------------------------------------------------------------------

params = {}

----------------------------------------------------------------------------------------------------

function init(version, trackingId, profileId, appName, appVersion)
 params.version   = version
 params.trackingId  = trackingId
 params.profileId   = profileId

 params.appName   = appName
 params.appVersion  = appVersion
end

----------------------------------------------------------------------------------------------------

function pageview(page)
    local data = ""
    data = data .. "v="   .. params.version
    data = data .. "&tid="  .. params.trackingId
    data = data .. "&cid="  .. params.profileId
    data = data .. "&t="  .. "appview"
    data = data .. "&an="  .. params.appName
    data = data .. "&av="  .. params.appVersion
    data = data .. "&cd="  .. page

    utils.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

----------------------------------------------------------------------------------------------------

function event(category, action)
    local data = ""
    data = data .. "v="   .. params.version
    data = data .. "&tid="  .. params.trackingId
    data = data .. "&cid="  .. params.profileId
    data = data .. "&t="  .. "event"
    data = data .. "&an="  .. params.appName
    data = data .. "&ec="  .. category
    data = data .. "&ea="  .. action

    utils.post(ANALYTICS_URL, data, nil, 'urlencoded')
end

