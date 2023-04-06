1. Execute amplify add auth from the root folder of the project. Answer the setup questions as follows:
    1. Do you want to use the default authentication and security configuration? -> Manual configuration
    2. Select the authentication/authorization services that you want to use: -> User Sign-Up & Sign-In only (Best used with a cloud API only)
    3. Provide a friendly name for your resource that will be used to label this category in the project: -> emobileappauth
    4. Provide a name for your user pool: -> mobile-app-users
    5. How do you want users to be able to sign in? -> Username
    6. Do you want to add User Pool Groups? -> No
    7. Do you want to add an admin queries API? -> No
    8. Multifactor authentication (MFA) user login options: -> OFF
    9. Specify an email verification subject: -> new_app1 App Verifizierungscode
    10. Specify an email verification message: -> Dein Verifizierungscode ist {####}.
    11. Do you want to override the default password policy for this User Pool? -> Yes
    12. Enter the minimum password length for this User Pool: -> 8
    13. Select the password character requirements for your userpool: (Press space to select, a to toggle all, i to invert selection) -> Select none
    14. What attributes are required for signing up? -> Preferred Username (This attribute is not supported by Facebook, Google, Login With Amazon, Sign in with Apple.) (deselect Email)
    15. Specify the app's refresh token expiration period (in days): -> 365
    16. Specify read attributes: -> Email, Preferred Username, Email Verified?
    17. Specify write attributes: -> Email
    18. Do you want to enable any of the following capabilities? -> Select none
    19. Do you want to use an OAuth flow? -> No
    20. ? Do you want to configure Lambda Triggers for Cognito? -> Yes
    21. ? Which triggers do you want to enable for Cognito -> Pre Sign-up
    22. ? What functionality do you want to use for Pre Sign-up -> Create your own module
    23. ? Do you want to edit your custom function now? -> No
2. Execute `amplify push` from the terminal.
3. Check the new cognito service has been added in AWS (check services -> Cognito, the user pool should appear here, and check amplify studio) 

After step 9 the auth service has been set up and you can create, login, logout and delete users. However, currently users need to verify their email to successfully create an account. To directly verify users, the pre sign up lambda function needs to configured. Proceed as follows:

4. Check the name of the pre sign up lambda trigger by opening following path: AWS Services -> Cognito -> Manage User Pools -> mobile-app-users-staging -> Triggers. The name of the pre sign up lambda function should read something like "mobileappauthPreSignup-staging"
5. Locate the function in AWS Services -> Lambda -> mobileappauthPreSignup-staging (find and select in the displayed function list)
6. Open the file "custom.js" and add the line 'event.response.autoConfirmUser = true;' to the function, the complete file should read as follows:
    ```
    /**
     * @type {import('@types/aws-lambda').APIGatewayProxyHandler}
     */
     exports.handler = async (event, context) => {
         // insert code to be executed by your lambda trigger
         event.response.autoConfirmUser = true;
         return event
     };
     ```
7. Open the file "event.json" and edit the response section, such that it reads as follows:
    ```
    "response": {
        "autoConfirmUser": "boolean",
        "autoVerifyPhone": "boolean",
        "autoVerifyEmail": "boolean"
    }
    ```
8. Click on deploy to save changes to the lambda function. Now You're done. The lambda trigger has been configured to auto verify users.




