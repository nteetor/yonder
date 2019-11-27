Shiny.addCustomMessageHandler("yonder:download", (msg) => {
  if (!(msg.filename && msg.token && msg.key)) {
    throw "invalid download event";
  }

  const uri = `/session/${ msg.token }/download/${ msg.key }`;

  let agent = window.navigator.userAgent;
  let ie = /MSIE/.test(agent);

  if (ie === true) {
    let xhr = new XMLHttpRequest();
    xhr.open("GET", uri);
    xhr.responseType = "blob";
    xhr.onload = () => saveAs(xhr.response, msg.filename);
    xhr.send();
  } else {
    fetch(uri)
      .then(res => res.blob())
      .then(blob => {
        saveAs(blob, msg.filename);
      });
  }
});
