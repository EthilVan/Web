module Marked {

   interface HighlightCallback {
      (code: string, lang: string): string;
   }

   interface Options {
      gfm: bool;
      pedantic: bool;
      sanitize: bool;
      highlight?: Marked.HighlightCallback;
   }

   interface Main {
      (markdown: string): string;
      setOptions(options: Marked.Options);
   }
}

declare var marked: Marked.Main;
