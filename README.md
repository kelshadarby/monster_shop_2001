# [Monster Shop](https://the-best-monster-shop.herokuapp.com/ "Official Monster Shop App")

Contributors:

[Fred Rondina](https://github.com/fredrondina96 "Fred Rondina's GitHub Profile"),
[Kelsha Darby](https://github.com/kelshadarby "Kelsha Darby's GitHub Profile") &
[Brian Greeson](https://github.com/brian-greeson "Brian Greeson's GitHub Profile")


## Application Description

"Monster Shop" is a fictitious e-commerce platform built for Turing School of Software Design's Back-End Module 2 project (Weeks 4 & 5). This app is a one-stop-shop for items ranging from pet products to bike parts. Can't find something you fancy? Custom merchants can be created with any number of items!

Users are able to register, login, add items to the cart and place the order. Users employed by a merchant on the site can fulfill part of a users order if that order contains items that they sell. If this all other items have already been fulfilled then an admin user will be able to ship that order.

This project was built in 10 days and implemented the following.

Design patterns:
- TDD (Test Driven Development)
- MVC (Model View Controller)
- CRUD Functionality (Create Read Update Destroy)
- ActiveRecord

Gems:
- Orderly
- BCrypt
- Shoulda Matchers
- Capybara


## Implementation

- Clone this repo onto your local machine
- Run the following commands in your terminal to get the code up and running on your local machine (make sure to run each of these without the $)

```
$ bundle
$ rake db:create
$ rake db:migrate
$ rake db:seed
```

## Dependencies
You must have the following to run this project
```
Rails 5.1.7
Ruby 2.6.x
Bundler version 2.0.1
```

## Testing
__To run the entire test suite on your local machine run the following command__
```
$ rspec
```

Note: You may need to prepend this command with `bundle exec`


__To run a specific test file run the following command__

```
$ rspec <file_path>
```

Note: Your file path may look something like `spec/features/items/index_spec.rb`


__To run a specific test within a test file run the following command__
```
$ rspec <file_path>:<line_number>
```

Notes:
- Your file path may look something like `spec/features/items/index_spec.rb`
- Your line number should be the line of the beginning of the `it` block
- Example: `spec/features/items/index_spec.rb:15`

## Authentication and Authorization
This project allows different types of users to do different actions.

They are laid out as follows:

__Admin User__
- _Permissions_:
  - View/edit their profile
  - View all orders in the system sorted by order status
  - Activating and deactivating merchants
  - Ship orders
  - Add edit and remove items
- _Restrictions_:
  - Create and place orders
  - Cannot use their powers for evil
- _Sample Credentials:_
```
username: admin_user@example.com
password: admin_password
```

__Merchant User__
- _Permissions_:
  - View/edit their profile
  - Fulfill orders that contain their items
  - Edit and delete their items
  - Add a new item to their inventory
- _Restrictions_:
  - Fulfill items in orders that are not that merchants items
  - Fulfill orders if their inventory of that item is not large enough
  - Create, update or delete any items that are not their own
- _Sample Credentials:_
```
username: merchant_user@example.com
password: merchant_password
```

__Default User__
- _Permissions_:
  - Add items to a cart
  - Place the order
  - View/edit their profile
- _Restrictions_:
  - View any admin or merchant specific pages
- _Sample Credentials:_
```
username: default_user@example.com
password: default_user_password
```

__Visitor__
- _Permissions_:
  - Add items to the cart
  - View all items
- _Restrictions_:
  - Checkout with their cart (they must login first)
  - View any admin or merchant specific pages
- There are no sample credentials


## User Views

### Admins

Not viewable by any other users

All orders
![Admin Dashboard](https://user-images.githubusercontent.com/55028065/79512340-7637a380-7ffe-11ea-9c5b-57b0e3802668.png "Admin Dashboard")


Admin profile
![Admin Profile Page](https://user-images.githubusercontent.com/55028065/79512345-78016700-7ffe-11ea-9298-39b0bcb05527.png "Admin Profile Page")

____
### Merchants

Also Viewable By:
  - Admin Users

Merchant Address & All Pending Orders
![Merchant Dashboard](https://user-images.githubusercontent.com/55028065/79512325-7041c280-7ffe-11ea-8520-32faf1267cc2.png "Merchant Dashboard")

Merchant Profile (Admins cannot view this page)
![Merchant User Profile](https://user-images.githubusercontent.com/55028065/79512342-76d03a00-7ffe-11ea-9b56-1d5404be4899.png "Merchant User Profile View")

Order Information (Only their items are shown)
![Merchant Order Show Page](https://user-images.githubusercontent.com/55028065/79512333-746de000-7ffe-11ea-947a-0bd456d82c96.png "Merchant Order Show Page")

Merchant's Items
![Merchant's Items](https://user-images.githubusercontent.com/55028065/79512347-79329400-7ffe-11ea-9ca8-4cb96adfd16a.png "Merchant's Items")

Editing a Merchant's Items
![Merchant Item Edit](https://user-images.githubusercontent.com/55028065/79512352-7a63c100-7ffe-11ea-8767-76085388e353.png "Merchant Item Update Page")

Adding a New Item
![New Item Page](https://user-images.githubusercontent.com/55028065/79512353-7afc5780-7ffe-11ea-9661-e7ecff15df7c.png "New Item Page")

____
### Default User

Also Viewable By:
  - Merchant Users

Cart View as a Registered User
![Cart View Page As Registered User](https://user-images.githubusercontent.com/55028065/79513377-ecd5a080-8000-11ea-8c4f-2f6eab09e850.png "Cart View Page As Registered User")

____
### Visitor (Not Registered)

Also Viewable By:
  - Default Users
  - Merchant Users

![Visitor Registration](https://user-images.githubusercontent.com/55028065/79512301-63bd6a00-7ffe-11ea-99e2-7490b967564d.png "Visitor Registration Page")

![Item Index Page](https://user-images.githubusercontent.com/55028065/79512311-67e98780-7ffe-11ea-96e5-6b9ce2a45613.png "All Items Page")

![Item Show Page](https://user-images.githubusercontent.com/55028065/79512318-6cae3b80-7ffe-11ea-9a66-05d2e82c4ca7.png "Specific Item Page")

![Cart View Page](https://user-images.githubusercontent.com/55028065/79512322-6f109580-7ffe-11ea-8d06-dba03c2aba2f.png "Cart View Page")


## Database Design
![Database Diagram](https://user-images.githubusercontent.com/55028065/79511093-d711ac80-7ffb-11ea-88cb-1caa1884652c.png "Monster Shop Database Layout")
