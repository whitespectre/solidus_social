## Unreleased

*   The `SolidusSocial::OAUTH_PROVIDERS` constant has been removed in favour
    of the `Spree::AuthenticationMethod.providers_options` class method. This is populated using
    the `Spree::SocialConfig#providers` Hash.
*   Use the install generator to import the solidus social initializer into your app.
    Please run `bundle exec rails g solidus_social:install` in order to upgrade.

## Solidus Social 1.0.0

*   Renamed SpreeSocial to SolidusSocial
*   Relaxed versions to support solidus 1.0+
*   Port of https://github.com/DynamoMTL/spree_social's solidus branch
