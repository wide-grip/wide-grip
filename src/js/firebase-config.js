function isDevelopment () {
  return window.location.host.includes('localhost')
}

export function config () {
  return isDevelopment() ? {
    apiKey: "AIzaSyBxq8JBDeqfCY4ZDuvKHNt_XVGlDgUgL2I",
    authDomain: "wide-grip-test.firebaseapp.com",
    databaseURL: "https://wide-grip-test.firebaseio.com",
    projectId: "wide-grip-test",
    storageBucket: "",
    messagingSenderId: "218170932406"
  } : {
    apiKey: "AIzaSyAS81CgQloq4VMbaVR6PBkAIIWyxD-UDOo",
    authDomain: "wide-grip.firebaseapp.com",
    databaseURL: "https://wide-grip.firebaseio.com",
    projectId: "wide-grip",
    storageBucket: "wide-grip.appspot.com",
    messagingSenderId: "673417757978"
  }
}
