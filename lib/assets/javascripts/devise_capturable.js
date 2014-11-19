function janrainDefaultSettings() {
  if (typeof window.janrain !== 'object') window.janrain = {};
  window.janrain.settings = {
    language: 'en',
    actionText: ' ',
    tokenAction: 'event',
    packages: ['login', 'capture'],
    capture: {
      flowVersion: 'HEAD',
      keepProfileCookieAfterLogout: true,
      modalCloseHtml: '<span class="janrain-icon-16 janrain-icon-ex2"></span>',
      federate: true,
      federateEnableSafari: true,
      responseType: 'code',
      setProfileCookie: true,
      transactionTimeout: 10000
    }
  };
};

function janrainInitLoad() {
  function isReady() { janrain.ready = true; };
  if (document.addEventListener) {
      document.addEventListener("DOMContentLoaded", isReady, false);
  } else {
      window.attachEvent('onload', isReady);
  }
  var e = document.createElement('script');
  e.type = 'text/javascript';
  e.id = 'janrainAuthWidget';
  var url = document.location.protocol === 'https:' ? 'https://' : 'http://';
  url += window.widget_load_path;
  e.src = url;
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(e, s);
};
