# ArmaTab

# Information

## What's this?

ArmaTab, which stands for Arma Tabernam, means Weapons Shop. And this app is basically, well...

An Arma Tabernam. Hence, ArmaTab. This is merely a small project to further familiarize myself with Flutter.

## How does it work?

### Authenticating Users

It's basically like a normal shop app but for weapons only (for now). The user logs in/signs up and they will then have an account. Once they're authenticated, they will be forwarded to the main page of the app.

### Shopping and Adding Products

In the main page of the app, users can navigate through multiple pages and manage things such as ordering products, adding they're own products, editing their products, and more. 

There are other features inside this app besides the main functionality of a shop, such as:

#### Auto Login

If the user is already logged in, for a certain amount of time they don't need to login unless they logged out manually. This makes sure the user don't have to log in every single time they open the app.

#### Auto Logout

_This is slightly technical._

Once a certain amount of time has passed, the user will automatically log out. This is done by utilizing the sign in data `Firebase` (the back-end I used) provides after the user sends a `post` request for authentication via sending the user's data in `json` format through the `Firebase Auth REST API` which then returns a response `json` data which contains:

```
{
- idToken      : The Firebase Auth ID token for the newly created/authenticated user.
- email        : The user's email.
- localId      : The uid of the user.
- expiresIn    : The amount of seconds until the `idToken` expires.
- refreshToken : The Firebase Auth refresh token for the user.

if the account already exists and is not newly created it also has this data:

- registered   : A value to see whether the user's email is registered or not.
}
```

Then the provided response data is used to manage the authentication state of our user. Also, after `expiresIn` amount of seconds has passed, the `idToken` expires and the user will automatically be logged out.

Further information regarding `Firebase` can be found in the official documentation for `Firebase` right [here](https://firebase.google.com/docs).

# Development

## Tools

The tools used to make this app are mainly only two, which are:
- The `Flutter` framework and SDK with the `Dart` language as the front-end of this app.
- `Firebase` for which I used its database service, authentication REST API, and the overall back-end of this app.

## Packages

I used several packages provided by the `Flutter` community which are:

```
- provider: ^5.0.0
- intl: ^0.17.0
- http: ^0.13.3
- shared_preferences: ^2.0.6
```

All of these packages can be found in the [pub.dev](https://pub.dev/) site which provides packages for `Dart` and `Flutter` for us to use which are provided by the `Dart` and `Flutter` community.

## Running

To run this app from your IDE, simply run the `main.dart` file attached inside of the `lib` folder. If that doesn't work, create a new `Flutter` project and then replacing the contents of the `lib` folder with the lib folder above, then add the packages and assets in this repository. Then, run the `main.dart` file. Or just install it to your phone/emulator.
