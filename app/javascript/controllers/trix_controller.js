import { Controller } from "@hotwired/stimulus"
import "./trix_underline_controller"
import "./trix_underline_extension_controller"

export default class extends Controller {
  static UNUSED_TOOLBAR_CLASSES = [
    // ".trix-button--icon-strike",
    // ".trix-button--icon-link",
    // ".trix-button-group--block-tools", // KEEP this visible so headings can be added
    ".trix-button-group--file-tools",
    ".trix-button-group--history-tools"
  ]

  connect() {
    this.element.addEventListener("trix-initialize", this.setupEditor)
    this.element.addEventListener("trix-action-invoke", this.onActionInvoke)
  }

  disconnect() {
    this.element.removeEventListener("trix-initialize", this.setupEditor)
    this.element.removeEventListener("trix-action-invoke", this.onActionInvoke)
  }

  onActionInvoke = (event) => {
    if (event.actionName === "attachLink") {
      this.onChange = (changeEvent) => {
        this.fixLinks(changeEvent)
        this.element.removeEventListener("trix-change", this.onChange)
        delete this.onChange
      }
      this.element.addEventListener("trix-change", this.onChange)
    }
  }


  fixLinks(event) {
    const trixEditor = event.target // the <trix-editor> element
    const editor = trixEditor.editor   // Trix editor instance

    // Get the document text and attributes
    const doc = editor.getDocument()

    // We'll iterate over the document's characters and fix links with missing protocol
    const length = doc.getLength()

    for (let i = 0; i < length; i++) {
      const attrs = doc.getAttributesAt(i)
      if (attrs.href) {
        if (!/^https?:\/\//i.test(attrs.href)) {
          const fixedHref = `http://${attrs.href}`
          // Update the link attribute in the range where this href applies
          // Here we select only the character at index i (usually enough)
          editor.setSelectedRange([i, i + 1])
          editor.setAttribute("href", fixedHref)
        }
      }
    }
  }



  setupEditor = (event) => {
    const editor = event.target;            // <trix-editor> element
    const toolbar = editor.toolbarElement;  // the toolbar DOM

    const isPostEdit = editor.closest(".post-edit-form");

    if (isPostEdit) {
      const headingButtons = toolbar.querySelectorAll("button[data-trix-attribute^='heading']");
      headingButtons.forEach(button => button.style.display = "none");
    }


    // 1. Remove unused toolbar buttons first
    this.constructor.UNUSED_TOOLBAR_CLASSES?.forEach?.((cls) => {
      toolbar.querySelector(cls)?.remove()
    })


    const buttonsToRemove = [
      ".trix-button--icon-heading-1",
      ".trix-button--icon-quote",
      ".trix-button--icon-code",
      ".trix-button--icon-bullet-list",
      ".trix-button--icon-number-list",
      ".trix-button--icon-decrease-nesting-level",
      ".trix-button--icon-increase-nesting-level"
    ]

    buttonsToRemove.forEach(selector => {
      const button = toolbar.querySelector(selector)
      if (button) button.remove()
    })


    // 2. Add custom underline attribute if not already defined
    if (!Trix.config.textAttributes.underline) {
      Trix.config.textAttributes.underline = {
        tagName: "u",
        style: { textDecoration: "underline" },
        inheritable: true,
        parser(element) {
          const style = window.getComputedStyle(element)
          return style.textDecoration === "underline"
        }
      }
    }

    // 3. Add underline button if it doesn't exist
    const textGroup = toolbar.querySelector(".trix-button-group--text-tools")
    if (textGroup && !textGroup.querySelector("[data-trix-attribute='underline']")) {
      const underlineBtn = document.createElement("button")
      underlineBtn.type = "button"
      underlineBtn.setAttribute("data-trix-attribute", "underline")
      underlineBtn.setAttribute("data-trix-key", "u")
      underlineBtn.setAttribute("tabindex", -1)
      underlineBtn.setAttribute("title", "Underline")
      underlineBtn.classList.add("trix-button", "trix-button--icon-underline")
      underlineBtn.innerHTML = '<i class="fa-solid fa-underline"></i>'
      textGroup.appendChild(underlineBtn)
    }

    // 4. Customize buttons icons (bold, italic, strike, link, underline)
    const boldButton = toolbar.querySelector("[data-trix-attribute='bold']")
    if (boldButton) {
      boldButton.innerHTML = '<i class="fa-solid fa-bold"></i>'
    }

    const italicButton = toolbar.querySelector("[data-trix-attribute='italic']")
    if (italicButton) {
      italicButton.innerHTML = '<i class="fa-solid fa-italic"></i>'
    }

    const strikeButton = toolbar.querySelector("[data-trix-attribute='strike']")
    if (strikeButton) {
      strikeButton.innerHTML = '<i class="fa-solid fa-strikethrough"></i>'
    }

    const linkButton = toolbar.querySelector("[data-trix-attribute='href']")
    if (linkButton) {
      linkButton.innerHTML = '<i class="fa-solid fa-link"></i>'
    }

    const underlineButton = toolbar.querySelector("[data-trix-attribute='underline']")
    if (underlineButton) {
      underlineButton.innerHTML = '<i class="fa-solid fa-underline"></i>'
    }



    // Trix.config.blockAttributes.blockquote = {
    //   tagName: "blockquote",
    //   terminal: true,
    //   breakOnReturn: true,
    //   group: false
    // }


    // 5. Define heading block attributes
    Trix.config.blockAttributes.heading1 = {
      tagName: "h1",
      terminal: true,
      breakOnReturn: true,
      group: false
    }

    Trix.config.blockAttributes.heading2 = {
      tagName: "h2",
      terminal: true,
      breakOnReturn: true,
      group: false
    }

    Trix.config.blockAttributes.heading3 = {
      tagName: "h3",
      terminal: true,
      breakOnReturn: true,
      group: false
    }

    // 6. Add heading and blockquote buttons to block-tools group
const blockGroup = toolbar.querySelector(".trix-button-group--block-tools")
if (blockGroup) {
  const addHeadingButton = (label, attribute) => {
    const button = document.createElement("button")
    button.setAttribute("type", "button")
    button.setAttribute("data-trix-attribute", attribute)
    button.setAttribute("title", label)
    button.classList.add("trix-button")
    button.innerHTML = label
    return button


  }

  // Add unordered list button (bullet points)
  const addUnorderedListButton = () => {
    const button = document.createElement("button")
    button.setAttribute("type", "button")
    button.setAttribute("data-trix-attribute", "bullet")
    button.setAttribute("title", "Bulleted List")
    button.classList.add("trix-button")
    button.innerHTML = '<i class="fa-solid fa-list-ul"></i>'
    return button
  }

  // Add ordered list button (numbered points)
  const addOrderedListButton = () => {
    const button = document.createElement("button")
    button.setAttribute("type", "button")
    button.setAttribute("data-trix-attribute", "number")
    button.setAttribute("title", "Numbered List")
    button.classList.add("trix-button")
    button.innerHTML = '<i class="fa-solid fa-list-ol"></i>'
    return button
  }

  blockGroup.appendChild(addUnorderedListButton())
  blockGroup.appendChild(addOrderedListButton())
  // Add heading buttons
  if (!isPostEdit) {
  blockGroup.appendChild(addHeadingButton("H1", "heading1"))
  blockGroup.appendChild(addHeadingButton("H2", "heading2"))
  blockGroup.appendChild(addHeadingButton("H3", "heading3"))
  }

//   // Add blockquote button
//   const addBlockquoteButton = () => {
//     const button = document.createElement("button")
//     button.setAttribute("type", "button")
//     button.setAttribute("data-trix-attribute", "blockquote")
//     button.setAttribute("title", "Blockquote")
//     button.classList.add("trix-button")
//     button.innerHTML = '<i class="fa-solid fa-quote-right"></i>'
//     return button
//   }

//   blockGroup.appendChild(addBlockquoteButton())
}

  }
}
