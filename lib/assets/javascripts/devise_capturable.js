function afterJanrainLogin(result, path, method)
{
  path = path || "/users/sign_in";
  method = method || "post";

  // create form
  var form  = $('<form accept-charset="UTF-8" action="' + path + '" method="' + method +'" id="capturable-inject-form"></form>');

  // create hidden div in form
  var hidden_els = $('<div style="margin:0;padding:0;display:inline"></div>');

  // add utf
  hidden_els.append('<input name="utf8" type="hidden" value="✓">');

  // grab forgery token
  var token_name = $("meta[name='csrf-param']").attr('content');
  var token_val = $("meta[name='csrf-token']").attr('content');
  if(token_name && token_val)
  {
    hidden_els.prepend('<input name="'+token_name +'" type="hidden" value="'+token_val+'">');
  }

  // append hidden els to form
  form.append(hidden_els);

  // add oauth code to form
  form.append('<input id="authorization-code" name="code" type="hidden" value="'+result.authorizationCode+'">');

  $('body').append(form);
  form.submit()
}

function janrainCaptureWidgetOnLoad() {

  // these settings will always be the same
  janrain.settings.capture.flowName = 'signIn';
  janrain.settings.capture.responseType = 'code';

  // these settings are never used but crashes the widget if not present
  janrain.settings.capture.redirectUri = 'http://stupidsettings.com';

  // go go widget go
  janrain.capture.ui.start();
  janrain.events.onCaptureLoginSuccess.addHandler(afterJanrainLogin);
  janrain.events.onCaptureRegistrationSuccess.addHandler(afterJanrainLogin);
}
