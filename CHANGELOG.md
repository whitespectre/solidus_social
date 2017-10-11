## Unreleased

## v1.2.0

- Switched to using the install generator to import the solidus social
  initializer into apps. **Please run `bundle exec rails g
  solidus_social:install` in order to upgrade.**
- Removed the `SolidusSocial::OAUTH_PROVIDERS` constant in favour of
  the `Spree::AuthenticationMethod.providers_options` class
  method. This is populated using the `Spree::SocialConfig#providers` Hash.
- Added support for Rails 5.1.
- Added Italian translations

## v1.1.0

- Added support for Solidus 2/Rails 5
- Bugfixes

## v1.0.0

- Renamed SpreeSocial to SolidusSocial
- Relaxed versions to support solidus 1.0+
- Port of https://github.com/DynamoMTL/spree_social's solidus branch
