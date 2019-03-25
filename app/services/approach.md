https://codeclimate.com/blog/7-ways-to-decompose-fat-activerecord-models/

**Extract Service Objects**
Some actions in a system warrant a Service Object to encapsulate their operation. 
I reach for Service Objects when an action meets one or more of these criteria:

- The action is complex (e.g. closing the books at the end of an accounting period)
- The action reaches across multiple models (e.g. an e-commerce purchase using Order, CreditCard and Customer objects)
- The action interacts with an external service (e.g. posting to social networks)
- The action is not a core concern of the underlying model (e.g. sweeping up outdated data after a certain time period).
- There are multiple ways of performing the action (e.g. authenticating with an access token or password). This is the Gang of Four Strategy pattern.
- As an example, we could pull a User#authenticate method out into a UserAuthenticator:

```
class UserAuthenticator
  def initialize(user)
    @user = user
  end

  def authenticate(unencrypted_password)
    return false unless @user

    if BCrypt::Password.new(@user.password_digest) == unencrypted_password
      @user
    else
      false
    end
  end
end
```

And the SessionsController would look like this:

```
class SessionsController < ApplicationController
  def create
    user = User.where(email: params[:email]).first

    if UserAuthenticator.new(user).authenticate(params[:password])
      self.current_user = user
      redirect_to dashboard_path
    else
      flash[:alert] = "Login failed."
      render "new"
    end
  end
end
````