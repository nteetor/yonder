export let fileInputBinding = new Shiny.InputBinding();

$(".yonder-file").on("click", ".input-group-append", function(e) {
  $(e.delegateTarget).find("input[type='file']").trigger("click");
});

$.extend(fileInputBinding, {
  Selector: {
    SELF: ".yonder-file[id]"
  },
  getValue: function(el) {
    return null;
  },
  sendFile: function(uri, job, file, final, el) {
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

        for (var i = 0; i < files.length; i++) {
          this.sendFile(uri, job, files[i], i === (files.length - 1), el);
        }
      },
      (err) => {
        console.error(`uploadInit request failed for ${ el.id }: ${ err }`);
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

Shiny.inputBindings.register(fileInputBinding, "yonder.fileInput");
