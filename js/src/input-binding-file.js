export let fileInputBinding = new Shiny.InputBinding();

$.extend(fileInputBinding, {
  find: (scope) => scope.querySelectorAll(".yonder-file[id]"),
  initialize: (el) => {
    let $el = $(el);

    $el.on("dragover", (e) => {
      e.stopPropagation();
      e.preventDefault();
    });

    $el.on("dragcenter", (e) => {
      e.stopPropagation();
      e.preventDefault();
    });

    $el.on("drop", (e) => {
      e.stopPropagation();
      e.preventDefault();

      fileInputBinding._upload(el, e.originalEvent.dataTransfer.files);
    });

    $el.on("change", (e) => {
      fileInputBinding._upload(el);
    });
  },
  getValue: (el) => null,
  receiveMessage: (el, msg) => {
    let input = el.querySelector("input");

    if (msg.enable) {
      input.removeAttribute("disabled");
    }

    if (msg.disable) {
      input.setAttribute("disabled", "");
    }

    if (msg.valid) {
      el.querySelector(".valid-feedback").innerHTML = msg.valid;
      input.classList.add("is-valid");
    }

    if (msg.invalid) {
      el.querySelector(".invalid-feedback").innerHTML = msg.invalid;
      input.classList.remove("is-invalid");
    }

    if (!msg.valid && !msg.invalid) {
      el.querySelector(".valid-feedback").innerHTML = "";
      el.querySelector(".invalid-feedback").innerHTML = "";
      input.classList.remove("is-valid");
      input.classList.remove("is-invalid");
    }
  },
  _post: function(uri, job, file, final, el) {
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
  _upload: function(el, files) {
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
          this._post(uri, job, files[i], i === (files.length - 1), el);
        }
      },
      (err) => {
        console.error(`uploadInit request failed for ${ el.id }: ${ err }`);
      }
    );
  }
});

document.addEventListener("DOMContentLoaded", () => {
  bsCustomFileInput.init(".yonder-file[id] input[type='file']");
});

Shiny.inputBindings.register(fileInputBinding, "yonder.fileInput");
