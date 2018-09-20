---
this: loginInput
filename: R/textual.R
layout: page
roxygen:
  title: Login input
  description: A composite input which consists of a username field and a password
    field.
  parameters:
  - name: id
    description: A character string specifying the HTML id of the login input.
  - name: '...'
    description: |-
      Additional named arguments passed as HTML attibutes to the login
      input.
  sections: ~
  return: ~
  family: inputs
  name: ~
  rdname: ~
  examples:
  - type: markdown
    value: |
      <h3>Something of a shortcut</h3>
  - type: source
    value: |2-

      loginInput(id = NULL)
  - type: output
    value: |-
      <div class="yonder-login col">
        <div class="form-group">
          <label class="form-control-label" for="login-18-203">Username</label>
          <input id="login-18-203" type="text" class="form-control"/>
        </div>
        <div class="form-group">
          <label class="form-control-label" for="login-631-74">Password</label>
          <input id="login-18-203" type="password" class="form-control"/>
        </div>
        <button class="btn btn-primary">Login</button>
      </div>
---
