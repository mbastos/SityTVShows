# iOS Challenge - Matheus  Bastos

## Project details

* Layout: View Code (UIKit)
* Architecture: MVVM

## Dependencies (Swift Package Manager)

* *Kingfisher*: for fetching and caching remote images
* *RxSwift*: for the bindings between view controllers and view models
* *RealmSwift*: for storing favorite shows

## Completed mandatory features

All mandatory features have been completed.

- [x] List all of the series contained in the API used by the paging scheme provided by the API.
- [x] Allow users to search series by name.
- [x] The listing and search views must show at least the name and poster image of the series.
- [x] After clicking on a series, the application should show the details of the series, showing the following information:
    - [x] Name
    - [x] Poster
    - [x] Days and time during which the series airs
    - [x] Genres
    - [x] Summary
    - [x] List of episodes separated by season
- [x] After clicking on an episode, the application should show the episode’s information, including:
    - [x] Name
    - [x] Number
    - [x] Season
    - [x] Summary
    - [x] Image, if there is one

## Completed optional features

Of the optional features, only the protection by PIN number hasn't been completed.

- [ ] Allow the user to set a PIN number to secure the application and prevent unauthorized users.
- [ ] For supported phones, the user must be able to choose if they want to enable fingerprint
authentication to avoid typing the PIN number while opening the app.
- [x] Allow the user to save a series as a favorite.
- [x] Allow the user to delete a series from the favorites list.
- [x] Allow the user to browse their favorite series in alphabetical order, and click on one to see its details.
- [x] Create a people search by listing the name and image of the person.
- [x] After clicking on a person, the application should show the details of that person, such as:
    - [x] Name
    - [x] Image
    - [x] Series they have participated in, with a link to the series details.
