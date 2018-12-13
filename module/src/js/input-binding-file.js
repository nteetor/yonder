export let fileInputBinding = new Shiny.InputBinding();

$.extend(fileInputBinding, {
  Selector: {
    SELF: ".yonder-file[id]",
    VALIDATE: "input[type='file']"
  },
  getValue: el => null,
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
            let $input = $(el).find("input[type='file']");
            $input.val("");
            $input.text("Choose file");
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
    if (!files) {
      return;
    }

    let info = Array.prototype.map.call(files, (f) => {
      return { "name": f.name, "size": f.size, "type": f.type };
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
  },
  subscribe: function(el, callback) {
    let $el = $(el);
    let input = el.querySelector("input[type='file']");

    $el.on("click.yonder", ".input-group-prepend, .input-group-append", (e) => {
      input.click();
    });

    if (el.querySelector("button") !== null) {
      $el.on("click.yonder", "button", (e) => {
        this._doUpload(el, input.files);
      });
    } else {
      $el.on("change.yonder", (e) => {
        this._doUpload(el, input.files);
      });
    }

    $el.on("dragover.yonder", (e) => {
      e.stopPropagation();
      e.preventDefault();
    });

    $el.on("dragenter.yonder", (e) => {
      e.stopPropagation();
      e.preventDefault();
    });

    $el.on("drop.yonder", (e) => {
      e.stopPropagation();
      e.preventDefault();

      if (input.hasAttribute("multiple")) {
        this._doUpload(el, e.originalEvent.dataTransfer.files);
      } else {
        this._doUpload(el, e.originalEvent.dataTransfer.files[0]);
      }
    });
  }
});

Shiny.inputBindings.register(fileInputBinding, "yonder.fileInput");
