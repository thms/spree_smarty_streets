# Spree smartystreets extension

The Spree smartystreets extension enables address validation via the smartystreets web service and county based decisions in spree

## Installation

1. Add the following to your Gemfile

<pre>
    gem 'spree_smarty_streets'
</pre>

2. Run `bundle install`

3. To setup the asset pipeline includes and copy migrations run: `rails g spree_smartystreets:install`


## Functions

1. Address validation

Shipping (and billing) addresses can be validated before submission to active shipping for rate requests, to get more accurate rates

2. County based function

The address validation also returns the county, which is useful for tax rate calculations and county based logic




## Setup

1. API Credentials

Create an account on smartystreets.com and enter the credentials in smarty_streets.yml

