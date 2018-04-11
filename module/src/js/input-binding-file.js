let fileInputBinding = new Shiny.InputBinding();

$.extend(fileInputBinding, {
  Selector: {
    SELF: ".dull-file-input"
  },
  getValue: function(el) {
    return null;
  },
  sendFile: function(uri, job, file, el) {
    let xhr = new XMLHttpRequest();
    xhr.open("POST", uri, true);
    xhr.setRequestHeader("Content-Type", "application/octet-stream");

    xhr.onreadystatechange = function() {
      if (xhr.readyState == XMLHttpRequest.DONE && xhr.status == 200) {
        Shiny.shinyapp.makeRequest(
          "uploadEnd",
          [job, el.id],
          (res) => {
            let $input = $(el).find("input[type='file']");
            $input.val("");
            $input.text("Choose file");
          },
          (err) => {
            throw err;
          }
        );
      }
    };

    xhr.send(file);
  },
  doUpload: function(el, files) {
    if (!files) {
      return;
    }

    let info = $.map(files, (f) => {
      return {name: f.name, size: f.size, type: f.type };
    });

    Shiny.shinyapp.makeRequest(
      "uploadInit",
      [info],
      (res) => {
        let job = res.jobId;
        let uri = res.uploadUrl;

        for (let f of files) {
          this.sendFile(uri, job, f, el);
        }
      },
      (err) => {
        throw err;
      }
    );
  },
  subscribe: function(el, callback) {
    let $input = $(el).find("input[type='file']");

    if (!$input.length) {
      return;
    }

    let input = $input.get(0);

    if ($(el).find(".btn").length) {
      $(el).on("click.fileInputBinding", ".btn", (e) => {
        this.doUpload(el, input.files);
      });
    } else {
      $(el).on("change.fileInputBinding", (e) => {
        this.doUpload(el, input.files);
      });
    }

    $(el).on("dragover.fileInputBinding", (e) => {
      e.stopPropagation();
      e.preventDefault();
    });
    $(el).on("dragenter.fileInputBinding", (e) => {
      e.stopPropagation();
      e.preventDefault();
    });
    $(el).on("drop.fileInputBinding", (e) => {
      e.stopPropagation();
      e.preventDefault();

      if (input.hasAttribute("multiple")) {
        this.doUpload(el, e.originalEvent.dataTransfer.files);
      } else {
        this.doUpload(el, e.originalEvent.dataTransfer.files[0]);
      }
    });
  },
  unsubscribe: function(el) {
    $(el).off(".fileInputBinding");
  }
});

Shiny.inputBindings.register(fileInputBinding, "dull.fileInput");
