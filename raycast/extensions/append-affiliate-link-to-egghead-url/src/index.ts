import { Clipboard, getSelectedText, showToast, Toast } from "@raycast/api";

// NTH: configurable affiliate link
function appendAffiliateLink(incomingURL: string) {
  const modifiedURL = new URL(incomingURL);
  modifiedURL.searchParams.set("af", "1x80ad");

  return modifiedURL.toString();
}

export default async function main() {
  try {
    const selectedText = await getSelectedText();

    if (!selectedText) {
      throw new Error("No text selected.");
    }

    if (!selectedText.includes("egghead.io")) {
      throw new Error("URL not supported.");
    }

    const appendedText = appendAffiliateLink(selectedText);

    await Clipboard.copy(appendedText);
    await Clipboard.paste(appendedText);
  } catch (error) {
    if (error instanceof Error) {
      await showToast({
        style: Toast.Style.Failure,
        title: error.message ? error.message : "Uknown error.",
        message: "Please try again.",
      });
    }
  }
}
