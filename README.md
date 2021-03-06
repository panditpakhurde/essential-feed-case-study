# Essential Feed App - Image Feed Feature

[![Build Status](https://travis-ci.com/panditpakhurde/essential-feed-case-study.svg?branch=master)](https://travis-ci.com/devessentials20/essential-feed-case-study)

## BDD Specs

### Narrative #1
> As an online customer I want the app to automatically load my latest image feed So I can always enjoy newest images of my friends 

### Scenarios (Acceptance Criteria)
```
Given the customer has connectivity
when customer request to see their feed
Then app should should display the latest feed from remote
  And replace the cache with the new feed
```

### Narrative #2
> As an offline customer I want the app to show the latest saved version of my image feed So I can always enjoy images of my friends

### Scenarios (Acceptance Criteria)
```
Given the cusotmer doesn't have connectivity
  And there's cached version of the feed
  And the cache is less than seven days old
when customer request to see the feed
Then the app should display the latest feed saved

Given the cusotmer doesn't have connectivity
  And there's cached version of the feed
  And the cache is seven days old or more
when customer request to see the feed
Then app should display an error message

Given the customer doesn't have connectivity
And the cache is empty
When customer request to see the feed
Then app should display an error message
```

## Use Cases

### Load Feed From Remote Use Case

#### Data:
* URL

#### Primary Course (Happy Path)
1. Execute "Load Image Feed" command with above data.
2. System downloads data from the URL
3. System validates downloaded data.
4. System creates image feed from the valid data.
5. System delivers image feed.

#### Invalid data - error course (sad path)
1. System delivers invalid data error

#### No connectivity - error course (sad path)
1. System delivers connectivity error


### Load Feed From Cache Use Case

#### Primary Course (Happy Path)
1. Execute "Load Image Feed" command with above data.
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.
4. System creates image feed from cached data.
5. System delivers image feed.

#### Retrieval Error Course (Sad Path)
2. System delivers error.

#### Expired Cache Course (Sad Path)
2. System delivers no feed images.

#### Empty Cache Course (Sad Path)
1. System delivers no feed images.

### Validate Feed Cache Use Case

#### Primary Course (Happy Path)
1. Execute "Validate Cache" command with above data.
2. System retrieves feed data from cache.
3. System validates cache is less than seven days old.

#### Retrieval Error Course (Sad Path)
1. System deletes cache.

#### Expired Cache Course (Sad Path)
1. System deletes cache.

#### Empty Cache Course (Sad Path)
1. System delivers no feed images.

### Cache Feed Use Case
#### Data:
* Image Feed

#### Primary Course (Happy Path)
1. Execute "Save Image Feed" command with above data.
2. System deletes old cache data.
3. System encodes image feed.
4. System timestamps the new cache.
5. System saves new cache data.
6. System delivers success message.

#### Deleting Error Course (Sad Path)
1. System delivers error.

#### Saving Error Course (Sad Path)
1. System delivers error.

### Flow Chart

![Image of FlowChart](https://github.com/devessentials20/essential-feed-case-study/blob/master/EssentialFeedApp%20-%20FlowChart.png)

### Architecture
![Image of Architecture](https://github.com/devessentials20/essential-feed-case-study/blob/master/DependencyDiagram_Composition.png)

## Model Specs

### Feed Image

Property | Type
-------- | --------
```id```       | ```UUID```
```description``` | ```String``` (optional)
```location```   | ```String``` (optional)
```url```    | ```URL```

### Payload Contract
```
GET *url* (TBD)

200 RESPONSE

{
      "items" : [
               {
                    "id" : "a UUID",
                    "description" : "a Description",
                    "location" : "a Location",
                    "image" : "https://a-image.url"
               },
               {
                    "id" : "another UUID",
                    "description" : "another Description",
                    "image" : "https://another-image.url"
               },
               {
                    "id" : "even another UUID",
                    "location" : "even another Location",
                    "image" : "https://even-another-image.url"
               },
               {
                    "id" : "yet another UUID",
                    "image" : "https://yet-another-image.url"
               }
               .....
      ]

}
```









