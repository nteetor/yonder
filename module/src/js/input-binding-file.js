export let fileInputBinding = new Shiny.InputBinding();

$.extend(fileInputBinding, {
  Selector: {
    SELF: ".yonder-file",
    VALIDATE: "input[type='file']"
  },
  Events: [
    {
      type: "change",
      callback: (el, _, self) => {
        if (el.querySelector("button") !== null) return;

        self._doUpload(el);
      }
    },
    {
      type: "click",
      selector: "button",
      callback: (el, _, self) => self._doUpload(el)
    },
    {
      type: "dragover",
      callback: (_, e) => {
        e.stopPropagation();
        e.preventDefault();
      }
    },
    {
      type: "dragcenter",
      callback: (_, e) => {
        e.stopPropagation();
        e.preventDefault();
      }
    },
    {
      type: "drop",
      callback: (el, e, self) => {
        e.stopPropagation();
        e.preventDefault();

        self._doUpload(el, e.originalEvent.dataTransfer.files);
      }
    }
  ],
  getValue: el => null,
  _value: () => null,
  _choice: () => null,
  _select: () => null,
  _clear: () => null,
  _enable: function(el, data) {
    el.querySelector("input[type='file']").removeAttribute("disabled");
  },
  _disable: function(el, data) {
    el.querySelector("input[type='file']").setAttribute("disabled", "");
  },
  _sendFile: function(uri, job, file, final, el) {
    let xhr = new XMLHttpRequest();
    xhr.open("POST", uri, true);
    xhr.setRequestHeader("Content-Type", "application/octet-stream");

    xhr.onreadystatechange = function() {
      if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200 && final) {
        Shiny.shinyapp.makeRequest(
          "uploadEnd",
          [job, el.id],
          (res) => {
            el.querySelector("input[type='file']").value = "";
          },
          (err) => {
            console.error(`uploadEnd request failed for ${ el.id }: ${ err }`);
          }
        );
      }
    };

    xhr.send(file);
  },
  _doUpload: function(el, files) {
    let input = el.querySelector("input[type='file']");

    if (files === undefined) {
      files = input.files;
    }

    if (!files) {
      return;
    }

    if (!input.hasAttribute("multiple")) {
      files = Array.prototype.slice.call(files, 0, 1);
    } else {
      files = Array.prototype.slice.call(files);
    }

    let info = files.map(f => {
      return { name: f.name, size: f.size, type: f.type };
    });

    Shiny.shinyapp.makeRequest(
      "uploadInit",
      [info],
      (res) => {
        let job = res.jobId;
        let uri = res.uploadUrl;

        for (var i = 0; i < files.length; i++) {
          this._sendFile(uri, job, files[i], i === (files.length - 1), el);
        }
      },
      (err) => {
        console.error(`uploadInit request failed for ${ el.id }: ${ err }`);
      }
    );
  }
});

Shiny.inputBindings.register(fileInputBinding, "yonder.fileInput");
