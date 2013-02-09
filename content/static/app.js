/*!
 * jQuery JavaScript Library v1.8.2
 * http://jquery.com/
 *
 * Includes Sizzle.js
 * http://sizzlejs.com/
 *
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license
 * http://jquery.org/license
 *
 * Date: Thu Sep 20 2012 21:13:05 GMT-0400 (Eastern Daylight Time)
 */
(function( window, undefined ) {
var
   // A central reference to the root jQuery(document)
   rootjQuery,

   // The deferred used on DOM ready
   readyList,

   // Use the correct document accordingly with window argument (sandbox)
   document = window.document,
   location = window.location,
   navigator = window.navigator,

   // Map over jQuery in case of overwrite
   _jQuery = window.jQuery,

   // Map over the $ in case of overwrite
   _$ = window.$,

   // Save a reference to some core methods
   core_push = Array.prototype.push,
   core_slice = Array.prototype.slice,
   core_indexOf = Array.prototype.indexOf,
   core_toString = Object.prototype.toString,
   core_hasOwn = Object.prototype.hasOwnProperty,
   core_trim = String.prototype.trim,

   // Define a local copy of jQuery
   jQuery = function( selector, context ) {
      // The jQuery object is actually just the init constructor 'enhanced'
      return new jQuery.fn.init( selector, context, rootjQuery );
   },

   // Used for matching numbers
   core_pnum = /[\-+]?(?:\d*\.|)\d+(?:[eE][\-+]?\d+|)/.source,

   // Used for detecting and trimming whitespace
   core_rnotwhite = /\S/,
   core_rspace = /\s+/,

   // Make sure we trim BOM and NBSP (here's looking at you, Safari 5.0 and IE)
   rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g,

   // A simple way to check for HTML strings
   // Prioritize #id over <tag> to avoid XSS via location.hash (#9521)
   rquickExpr = /^(?:[^#<]*(<[\w\W]+>)[^>]*$|#([\w\-]*)$)/,

   // Match a standalone tag
   rsingleTag = /^<(\w+)\s*\/?>(?:<\/\1>|)$/,

   // JSON RegExp
   rvalidchars = /^[\],:{}\s]*$/,
   rvalidbraces = /(?:^|:|,)(?:\s*\[)+/g,
   rvalidescape = /\\(?:["\\\/bfnrt]|u[\da-fA-F]{4})/g,
   rvalidtokens = /"[^"\\\r\n]*"|true|false|null|-?(?:\d\d*\.|)\d+(?:[eE][\-+]?\d+|)/g,

   // Matches dashed string for camelizing
   rmsPrefix = /^-ms-/,
   rdashAlpha = /-([\da-z])/gi,

   // Used by jQuery.camelCase as callback to replace()
   fcamelCase = function( all, letter ) {
      return ( letter + "" ).toUpperCase();
   },

   // The ready event handler and self cleanup method
   DOMContentLoaded = function() {
      if ( document.addEventListener ) {
         document.removeEventListener( "DOMContentLoaded", DOMContentLoaded, false );
         jQuery.ready();
      } else if ( document.readyState === "complete" ) {
         // we're here because readyState === "complete" in oldIE
         // which is good enough for us to call the dom ready!
         document.detachEvent( "onreadystatechange", DOMContentLoaded );
         jQuery.ready();
      }
   },

   // [[Class]] -> type pairs
   class2type = {};

jQuery.fn = jQuery.prototype = {
   constructor: jQuery,
   init: function( selector, context, rootjQuery ) {
      var match, elem, ret, doc;

      // Handle $(""), $(null), $(undefined), $(false)
      if ( !selector ) {
         return this;
      }

      // Handle $(DOMElement)
      if ( selector.nodeType ) {
         this.context = this[0] = selector;
         this.length = 1;
         return this;
      }

      // Handle HTML strings
      if ( typeof selector === "string" ) {
         if ( selector.charAt(0) === "<" && selector.charAt( selector.length - 1 ) === ">" && selector.length >= 3 ) {
            // Assume that strings that start and end with <> are HTML and skip the regex check
            match = [ null, selector, null ];

         } else {
            match = rquickExpr.exec( selector );
         }

         // Match html or make sure no context is specified for #id
         if ( match && (match[1] || !context) ) {

            // HANDLE: $(html) -> $(array)
            if ( match[1] ) {
               context = context instanceof jQuery ? context[0] : context;
               doc = ( context && context.nodeType ? context.ownerDocument || context : document );

               // scripts is true for back-compat
               selector = jQuery.parseHTML( match[1], doc, true );
               if ( rsingleTag.test( match[1] ) && jQuery.isPlainObject( context ) ) {
                  this.attr.call( selector, context, true );
               }

               return jQuery.merge( this, selector );

            // HANDLE: $(#id)
            } else {
               elem = document.getElementById( match[2] );

               // Check parentNode to catch when Blackberry 4.6 returns
               // nodes that are no longer in the document #6963
               if ( elem && elem.parentNode ) {
                  // Handle the case where IE and Opera return items
                  // by name instead of ID
                  if ( elem.id !== match[2] ) {
                     return rootjQuery.find( selector );
                  }

                  // Otherwise, we inject the element directly into the jQuery object
                  this.length = 1;
                  this[0] = elem;
               }

               this.context = document;
               this.selector = selector;
               return this;
            }

         // HANDLE: $(expr, $(...))
         } else if ( !context || context.jquery ) {
            return ( context || rootjQuery ).find( selector );

         // HANDLE: $(expr, context)
         // (which is just equivalent to: $(context).find(expr)
         } else {
            return this.constructor( context ).find( selector );
         }

      // HANDLE: $(function)
      // Shortcut for document ready
      } else if ( jQuery.isFunction( selector ) ) {
         return rootjQuery.ready( selector );
      }

      if ( selector.selector !== undefined ) {
         this.selector = selector.selector;
         this.context = selector.context;
      }

      return jQuery.makeArray( selector, this );
   },

   // Start with an empty selector
   selector: "",

   // The current version of jQuery being used
   jquery: "1.8.2",

   // The default length of a jQuery object is 0
   length: 0,

   // The number of elements contained in the matched element set
   size: function() {
      return this.length;
   },

   toArray: function() {
      return core_slice.call( this );
   },

   // Get the Nth element in the matched element set OR
   // Get the whole matched element set as a clean array
   get: function( num ) {
      return num == null ?

         // Return a 'clean' array
         this.toArray() :

         // Return just the object
         ( num < 0 ? this[ this.length + num ] : this[ num ] );
   },

   // Take an array of elements and push it onto the stack
   // (returning the new matched element set)
   pushStack: function( elems, name, selector ) {

      // Build a new jQuery matched element set
      var ret = jQuery.merge( this.constructor(), elems );

      // Add the old object onto the stack (as a reference)
      ret.prevObject = this;

      ret.context = this.context;

      if ( name === "find" ) {
         ret.selector = this.selector + ( this.selector ? " " : "" ) + selector;
      } else if ( name ) {
         ret.selector = this.selector + "." + name + "(" + selector + ")";
      }

      // Return the newly-formed element set
      return ret;
   },

   // Execute a callback for every element in the matched set.
   // (You can seed the arguments with an array of args, but this is
   // only used internally.)
   each: function( callback, args ) {
      return jQuery.each( this, callback, args );
   },

   ready: function( fn ) {
      // Add the callback
      jQuery.ready.promise().done( fn );

      return this;
   },

   eq: function( i ) {
      i = +i;
      return i === -1 ?
         this.slice( i ) :
         this.slice( i, i + 1 );
   },

   first: function() {
      return this.eq( 0 );
   },

   last: function() {
      return this.eq( -1 );
   },

   slice: function() {
      return this.pushStack( core_slice.apply( this, arguments ),
         "slice", core_slice.call(arguments).join(",") );
   },

   map: function( callback ) {
      return this.pushStack( jQuery.map(this, function( elem, i ) {
         return callback.call( elem, i, elem );
      }));
   },

   end: function() {
      return this.prevObject || this.constructor(null);
   },

   // For internal use only.
   // Behaves like an Array's method, not like a jQuery method.
   push: core_push,
   sort: [].sort,
   splice: [].splice
};

// Give the init function the jQuery prototype for later instantiation
jQuery.fn.init.prototype = jQuery.fn;

jQuery.extend = jQuery.fn.extend = function() {
   var options, name, src, copy, copyIsArray, clone,
      target = arguments[0] || {},
      i = 1,
      length = arguments.length,
      deep = false;

   // Handle a deep copy situation
   if ( typeof target === "boolean" ) {
      deep = target;
      target = arguments[1] || {};
      // skip the boolean and the target
      i = 2;
   }

   // Handle case when target is a string or something (possible in deep copy)
   if ( typeof target !== "object" && !jQuery.isFunction(target) ) {
      target = {};
   }

   // extend jQuery itself if only one argument is passed
   if ( length === i ) {
      target = this;
      --i;
   }

   for ( ; i < length; i++ ) {
      // Only deal with non-null/undefined values
      if ( (options = arguments[ i ]) != null ) {
         // Extend the base object
         for ( name in options ) {
            src = target[ name ];
            copy = options[ name ];

            // Prevent never-ending loop
            if ( target === copy ) {
               continue;
            }

            // Recurse if we're merging plain objects or arrays
            if ( deep && copy && ( jQuery.isPlainObject(copy) || (copyIsArray = jQuery.isArray(copy)) ) ) {
               if ( copyIsArray ) {
                  copyIsArray = false;
                  clone = src && jQuery.isArray(src) ? src : [];

               } else {
                  clone = src && jQuery.isPlainObject(src) ? src : {};
               }

               // Never move original objects, clone them
               target[ name ] = jQuery.extend( deep, clone, copy );

            // Don't bring in undefined values
            } else if ( copy !== undefined ) {
               target[ name ] = copy;
            }
         }
      }
   }

   // Return the modified object
   return target;
};

jQuery.extend({
   noConflict: function( deep ) {
      if ( window.$ === jQuery ) {
         window.$ = _$;
      }

      if ( deep && window.jQuery === jQuery ) {
         window.jQuery = _jQuery;
      }

      return jQuery;
   },

   // Is the DOM ready to be used? Set to true once it occurs.
   isReady: false,

   // A counter to track how many items to wait for before
   // the ready event fires. See #6781
   readyWait: 1,

   // Hold (or release) the ready event
   holdReady: function( hold ) {
      if ( hold ) {
         jQuery.readyWait++;
      } else {
         jQuery.ready( true );
      }
   },

   // Handle when the DOM is ready
   ready: function( wait ) {

      // Abort if there are pending holds or we're already ready
      if ( wait === true ? --jQuery.readyWait : jQuery.isReady ) {
         return;
      }

      // Make sure body exists, at least, in case IE gets a little overzealous (ticket #5443).
      if ( !document.body ) {
         return setTimeout( jQuery.ready, 1 );
      }

      // Remember that the DOM is ready
      jQuery.isReady = true;

      // If a normal DOM Ready event fired, decrement, and wait if need be
      if ( wait !== true && --jQuery.readyWait > 0 ) {
         return;
      }

      // If there are functions bound, to execute
      readyList.resolveWith( document, [ jQuery ] );

      // Trigger any bound ready events
      if ( jQuery.fn.trigger ) {
         jQuery( document ).trigger("ready").off("ready");
      }
   },

   // See test/unit/core.js for details concerning isFunction.
   // Since version 1.3, DOM methods and functions like alert
   // aren't supported. They return false on IE (#2968).
   isFunction: function( obj ) {
      return jQuery.type(obj) === "function";
   },

   isArray: Array.isArray || function( obj ) {
      return jQuery.type(obj) === "array";
   },

   isWindow: function( obj ) {
      return obj != null && obj == obj.window;
   },

   isNumeric: function( obj ) {
      return !isNaN( parseFloat(obj) ) && isFinite( obj );
   },

   type: function( obj ) {
      return obj == null ?
         String( obj ) :
         class2type[ core_toString.call(obj) ] || "object";
   },

   isPlainObject: function( obj ) {
      // Must be an Object.
      // Because of IE, we also have to check the presence of the constructor property.
      // Make sure that DOM nodes and window objects don't pass through, as well
      if ( !obj || jQuery.type(obj) !== "object" || obj.nodeType || jQuery.isWindow( obj ) ) {
         return false;
      }

      try {
         // Not own constructor property must be Object
         if ( obj.constructor &&
            !core_hasOwn.call(obj, "constructor") &&
            !core_hasOwn.call(obj.constructor.prototype, "isPrototypeOf") ) {
            return false;
         }
      } catch ( e ) {
         // IE8,9 Will throw exceptions on certain host objects #9897
         return false;
      }

      // Own properties are enumerated firstly, so to speed up,
      // if last one is own, then all properties are own.

      var key;
      for ( key in obj ) {}

      return key === undefined || core_hasOwn.call( obj, key );
   },

   isEmptyObject: function( obj ) {
      var name;
      for ( name in obj ) {
         return false;
      }
      return true;
   },

   error: function( msg ) {
      throw new Error( msg );
   },

   // data: string of html
   // context (optional): If specified, the fragment will be created in this context, defaults to document
   // scripts (optional): If true, will include scripts passed in the html string
   parseHTML: function( data, context, scripts ) {
      var parsed;
      if ( !data || typeof data !== "string" ) {
         return null;
      }
      if ( typeof context === "boolean" ) {
         scripts = context;
         context = 0;
      }
      context = context || document;

      // Single tag
      if ( (parsed = rsingleTag.exec( data )) ) {
         return [ context.createElement( parsed[1] ) ];
      }

      parsed = jQuery.buildFragment( [ data ], context, scripts ? null : [] );
      return jQuery.merge( [],
         (parsed.cacheable ? jQuery.clone( parsed.fragment ) : parsed.fragment).childNodes );
   },

   parseJSON: function( data ) {
      if ( !data || typeof data !== "string") {
         return null;
      }

      // Make sure leading/trailing whitespace is removed (IE can't handle it)
      data = jQuery.trim( data );

      // Attempt to parse using the native JSON parser first
      if ( window.JSON && window.JSON.parse ) {
         return window.JSON.parse( data );
      }

      // Make sure the incoming data is actual JSON
      // Logic borrowed from http://json.org/json2.js
      if ( rvalidchars.test( data.replace( rvalidescape, "@" )
         .replace( rvalidtokens, "]" )
         .replace( rvalidbraces, "")) ) {

         return ( new Function( "return " + data ) )();

      }
      jQuery.error( "Invalid JSON: " + data );
   },

   // Cross-browser xml parsing
   parseXML: function( data ) {
      var xml, tmp;
      if ( !data || typeof data !== "string" ) {
         return null;
      }
      try {
         if ( window.DOMParser ) { // Standard
            tmp = new DOMParser();
            xml = tmp.parseFromString( data , "text/xml" );
         } else { // IE
            xml = new ActiveXObject( "Microsoft.XMLDOM" );
            xml.async = "false";
            xml.loadXML( data );
         }
      } catch( e ) {
         xml = undefined;
      }
      if ( !xml || !xml.documentElement || xml.getElementsByTagName( "parsererror" ).length ) {
         jQuery.error( "Invalid XML: " + data );
      }
      return xml;
   },

   noop: function() {},

   // Evaluates a script in a global context
   // Workarounds based on findings by Jim Driscoll
   // http://weblogs.java.net/blog/driscoll/archive/2009/09/08/eval-javascript-global-context
   globalEval: function( data ) {
      if ( data && core_rnotwhite.test( data ) ) {
         // We use execScript on Internet Explorer
         // We use an anonymous function so that context is window
         // rather than jQuery in Firefox
         ( window.execScript || function( data ) {
            window[ "eval" ].call( window, data );
         } )( data );
      }
   },

   // Convert dashed to camelCase; used by the css and data modules
   // Microsoft forgot to hump their vendor prefix (#9572)
   camelCase: function( string ) {
      return string.replace( rmsPrefix, "ms-" ).replace( rdashAlpha, fcamelCase );
   },

   nodeName: function( elem, name ) {
      return elem.nodeName && elem.nodeName.toLowerCase() === name.toLowerCase();
   },

   // args is for internal usage only
   each: function( obj, callback, args ) {
      var name,
         i = 0,
         length = obj.length,
         isObj = length === undefined || jQuery.isFunction( obj );

      if ( args ) {
         if ( isObj ) {
            for ( name in obj ) {
               if ( callback.apply( obj[ name ], args ) === false ) {
                  break;
               }
            }
         } else {
            for ( ; i < length; ) {
               if ( callback.apply( obj[ i++ ], args ) === false ) {
                  break;
               }
            }
         }

      // A special, fast, case for the most common use of each
      } else {
         if ( isObj ) {
            for ( name in obj ) {
               if ( callback.call( obj[ name ], name, obj[ name ] ) === false ) {
                  break;
               }
            }
         } else {
            for ( ; i < length; ) {
               if ( callback.call( obj[ i ], i, obj[ i++ ] ) === false ) {
                  break;
               }
            }
         }
      }

      return obj;
   },

   // Use native String.trim function wherever possible
   trim: core_trim && !core_trim.call("\uFEFF\xA0") ?
      function( text ) {
         return text == null ?
            "" :
            core_trim.call( text );
      } :

      // Otherwise use our own trimming functionality
      function( text ) {
         return text == null ?
            "" :
            ( text + "" ).replace( rtrim, "" );
      },

   // results is for internal usage only
   makeArray: function( arr, results ) {
      var type,
         ret = results || [];

      if ( arr != null ) {
         // The window, strings (and functions) also have 'length'
         // Tweaked logic slightly to handle Blackberry 4.7 RegExp issues #6930
         type = jQuery.type( arr );

         if ( arr.length == null || type === "string" || type === "function" || type === "regexp" || jQuery.isWindow( arr ) ) {
            core_push.call( ret, arr );
         } else {
            jQuery.merge( ret, arr );
         }
      }

      return ret;
   },

   inArray: function( elem, arr, i ) {
      var len;

      if ( arr ) {
         if ( core_indexOf ) {
            return core_indexOf.call( arr, elem, i );
         }

         len = arr.length;
         i = i ? i < 0 ? Math.max( 0, len + i ) : i : 0;

         for ( ; i < len; i++ ) {
            // Skip accessing in sparse arrays
            if ( i in arr && arr[ i ] === elem ) {
               return i;
            }
         }
      }

      return -1;
   },

   merge: function( first, second ) {
      var l = second.length,
         i = first.length,
         j = 0;

      if ( typeof l === "number" ) {
         for ( ; j < l; j++ ) {
            first[ i++ ] = second[ j ];
         }

      } else {
         while ( second[j] !== undefined ) {
            first[ i++ ] = second[ j++ ];
         }
      }

      first.length = i;

      return first;
   },

   grep: function( elems, callback, inv ) {
      var retVal,
         ret = [],
         i = 0,
         length = elems.length;
      inv = !!inv;

      // Go through the array, only saving the items
      // that pass the validator function
      for ( ; i < length; i++ ) {
         retVal = !!callback( elems[ i ], i );
         if ( inv !== retVal ) {
            ret.push( elems[ i ] );
         }
      }

      return ret;
   },

   // arg is for internal usage only
   map: function( elems, callback, arg ) {
      var value, key,
         ret = [],
         i = 0,
         length = elems.length,
         // jquery objects are treated as arrays
         isArray = elems instanceof jQuery || length !== undefined && typeof length === "number" && ( ( length > 0 && elems[ 0 ] && elems[ length -1 ] ) || length === 0 || jQuery.isArray( elems ) ) ;

      // Go through the array, translating each of the items to their
      if ( isArray ) {
         for ( ; i < length; i++ ) {
            value = callback( elems[ i ], i, arg );

            if ( value != null ) {
               ret[ ret.length ] = value;
            }
         }

      // Go through every key on the object,
      } else {
         for ( key in elems ) {
            value = callback( elems[ key ], key, arg );

            if ( value != null ) {
               ret[ ret.length ] = value;
            }
         }
      }

      // Flatten any nested arrays
      return ret.concat.apply( [], ret );
   },

   // A global GUID counter for objects
   guid: 1,

   // Bind a function to a context, optionally partially applying any
   // arguments.
   proxy: function( fn, context ) {
      var tmp, args, proxy;

      if ( typeof context === "string" ) {
         tmp = fn[ context ];
         context = fn;
         fn = tmp;
      }

      // Quick check to determine if target is callable, in the spec
      // this throws a TypeError, but we will just return undefined.
      if ( !jQuery.isFunction( fn ) ) {
         return undefined;
      }

      // Simulated bind
      args = core_slice.call( arguments, 2 );
      proxy = function() {
         return fn.apply( context, args.concat( core_slice.call( arguments ) ) );
      };

      // Set the guid of unique handler to the same of original handler, so it can be removed
      proxy.guid = fn.guid = fn.guid || jQuery.guid++;

      return proxy;
   },

   // Multifunctional method to get and set values of a collection
   // The value/s can optionally be executed if it's a function
   access: function( elems, fn, key, value, chainable, emptyGet, pass ) {
      var exec,
         bulk = key == null,
         i = 0,
         length = elems.length;

      // Sets many values
      if ( key && typeof key === "object" ) {
         for ( i in key ) {
            jQuery.access( elems, fn, i, key[i], 1, emptyGet, value );
         }
         chainable = 1;

      // Sets one value
      } else if ( value !== undefined ) {
         // Optionally, function values get executed if exec is true
         exec = pass === undefined && jQuery.isFunction( value );

         if ( bulk ) {
            // Bulk operations only iterate when executing function values
            if ( exec ) {
               exec = fn;
               fn = function( elem, key, value ) {
                  return exec.call( jQuery( elem ), value );
               };

            // Otherwise they run against the entire set
            } else {
               fn.call( elems, value );
               fn = null;
            }
         }

         if ( fn ) {
            for (; i < length; i++ ) {
               fn( elems[i], key, exec ? value.call( elems[i], i, fn( elems[i], key ) ) : value, pass );
            }
         }

         chainable = 1;
      }

      return chainable ?
         elems :

         // Gets
         bulk ?
            fn.call( elems ) :
            length ? fn( elems[0], key ) : emptyGet;
   },

   now: function() {
      return ( new Date() ).getTime();
   }
});

jQuery.ready.promise = function( obj ) {
   if ( !readyList ) {

      readyList = jQuery.Deferred();

      // Catch cases where $(document).ready() is called after the browser event has already occurred.
      // we once tried to use readyState "interactive" here, but it caused issues like the one
      // discovered by ChrisS here: http://bugs.jquery.com/ticket/12282#comment:15
      if ( document.readyState === "complete" ) {
         // Handle it asynchronously to allow scripts the opportunity to delay ready
         setTimeout( jQuery.ready, 1 );

      // Standards-based browsers support DOMContentLoaded
      } else if ( document.addEventListener ) {
         // Use the handy event callback
         document.addEventListener( "DOMContentLoaded", DOMContentLoaded, false );

         // A fallback to window.onload, that will always work
         window.addEventListener( "load", jQuery.ready, false );

      // If IE event model is used
      } else {
         // Ensure firing before onload, maybe late but safe also for iframes
         document.attachEvent( "onreadystatechange", DOMContentLoaded );

         // A fallback to window.onload, that will always work
         window.attachEvent( "onload", jQuery.ready );

         // If IE and not a frame
         // continually check to see if the document is ready
         var top = false;

         try {
            top = window.frameElement == null && document.documentElement;
         } catch(e) {}

         if ( top && top.doScroll ) {
            (function doScrollCheck() {
               if ( !jQuery.isReady ) {

                  try {
                     // Use the trick by Diego Perini
                     // http://javascript.nwbox.com/IEContentLoaded/
                     top.doScroll("left");
                  } catch(e) {
                     return setTimeout( doScrollCheck, 50 );
                  }

                  // and execute any waiting functions
                  jQuery.ready();
               }
            })();
         }
      }
   }
   return readyList.promise( obj );
};

// Populate the class2type map
jQuery.each("Boolean Number String Function Array Date RegExp Object".split(" "), function(i, name) {
   class2type[ "[object " + name + "]" ] = name.toLowerCase();
});

// All jQuery objects should point back to these
rootjQuery = jQuery(document);
// String to Object options format cache
var optionsCache = {};

// Convert String-formatted options into Object-formatted ones and store in cache
function createOptions( options ) {
   var object = optionsCache[ options ] = {};
   jQuery.each( options.split( core_rspace ), function( _, flag ) {
      object[ flag ] = true;
   });
   return object;
}

/*
 * Create a callback list using the following parameters:
 *
 * options: an optional list of space-separated options that will change how
 *       the callback list behaves or a more traditional option object
 *
 * By default a callback list will act like an event callback list and can be
 * "fired" multiple times.
 *
 * Possible options:
 *
 * once:       will ensure the callback list can only be fired once (like a Deferred)
 *
 * memory:        will keep track of previous values and will call any callback added
 *             after the list has been fired right away with the latest "memorized"
 *             values (like a Deferred)
 *
 * unique:        will ensure a callback can only be added once (no duplicate in the list)
 *
 * stopOnFalse:   interrupt callings when a callback returns false
 *
 */
jQuery.Callbacks = function( options ) {

   // Convert options from String-formatted to Object-formatted if needed
   // (we check in cache first)
   options = typeof options === "string" ?
      ( optionsCache[ options ] || createOptions( options ) ) :
      jQuery.extend( {}, options );

   var // Last fire value (for non-forgettable lists)
      memory,
      // Flag to know if list was already fired
      fired,
      // Flag to know if list is currently firing
      firing,
      // First callback to fire (used internally by add and fireWith)
      firingStart,
      // End of the loop when firing
      firingLength,
      // Index of currently firing callback (modified by remove if needed)
      firingIndex,
      // Actual callback list
      list = [],
      // Stack of fire calls for repeatable lists
      stack = !options.once && [],
      // Fire callbacks
      fire = function( data ) {
         memory = options.memory && data;
         fired = true;
         firingIndex = firingStart || 0;
         firingStart = 0;
         firingLength = list.length;
         firing = true;
         for ( ; list && firingIndex < firingLength; firingIndex++ ) {
            if ( list[ firingIndex ].apply( data[ 0 ], data[ 1 ] ) === false && options.stopOnFalse ) {
               memory = false; // To prevent further calls using add
               break;
            }
         }
         firing = false;
         if ( list ) {
            if ( stack ) {
               if ( stack.length ) {
                  fire( stack.shift() );
               }
            } else if ( memory ) {
               list = [];
            } else {
               self.disable();
            }
         }
      },
      // Actual Callbacks object
      self = {
         // Add a callback or a collection of callbacks to the list
         add: function() {
            if ( list ) {
               // First, we save the current length
               var start = list.length;
               (function add( args ) {
                  jQuery.each( args, function( _, arg ) {
                     var type = jQuery.type( arg );
                     if ( type === "function" && ( !options.unique || !self.has( arg ) ) ) {
                        list.push( arg );
                     } else if ( arg && arg.length && type !== "string" ) {
                        // Inspect recursively
                        add( arg );
                     }
                  });
               })( arguments );
               // Do we need to add the callbacks to the
               // current firing batch?
               if ( firing ) {
                  firingLength = list.length;
               // With memory, if we're not firing then
               // we should call right away
               } else if ( memory ) {
                  firingStart = start;
                  fire( memory );
               }
            }
            return this;
         },
         // Remove a callback from the list
         remove: function() {
            if ( list ) {
               jQuery.each( arguments, function( _, arg ) {
                  var index;
                  while( ( index = jQuery.inArray( arg, list, index ) ) > -1 ) {
                     list.splice( index, 1 );
                     // Handle firing indexes
                     if ( firing ) {
                        if ( index <= firingLength ) {
                           firingLength--;
                        }
                        if ( index <= firingIndex ) {
                           firingIndex--;
                        }
                     }
                  }
               });
            }
            return this;
         },
         // Control if a given callback is in the list
         has: function( fn ) {
            return jQuery.inArray( fn, list ) > -1;
         },
         // Remove all callbacks from the list
         empty: function() {
            list = [];
            return this;
         },
         // Have the list do nothing anymore
         disable: function() {
            list = stack = memory = undefined;
            return this;
         },
         // Is it disabled?
         disabled: function() {
            return !list;
         },
         // Lock the list in its current state
         lock: function() {
            stack = undefined;
            if ( !memory ) {
               self.disable();
            }
            return this;
         },
         // Is it locked?
         locked: function() {
            return !stack;
         },
         // Call all callbacks with the given context and arguments
         fireWith: function( context, args ) {
            args = args || [];
            args = [ context, args.slice ? args.slice() : args ];
            if ( list && ( !fired || stack ) ) {
               if ( firing ) {
                  stack.push( args );
               } else {
                  fire( args );
               }
            }
            return this;
         },
         // Call all the callbacks with the given arguments
         fire: function() {
            self.fireWith( this, arguments );
            return this;
         },
         // To know if the callbacks have already been called at least once
         fired: function() {
            return !!fired;
         }
      };

   return self;
};
jQuery.extend({

   Deferred: function( func ) {
      var tuples = [
            // action, add listener, listener list, final state
            [ "resolve", "done", jQuery.Callbacks("once memory"), "resolved" ],
            [ "reject", "fail", jQuery.Callbacks("once memory"), "rejected" ],
            [ "notify", "progress", jQuery.Callbacks("memory") ]
         ],
         state = "pending",
         promise = {
            state: function() {
               return state;
            },
            always: function() {
               deferred.done( arguments ).fail( arguments );
               return this;
            },
            then: function( /* fnDone, fnFail, fnProgress */ ) {
               var fns = arguments;
               return jQuery.Deferred(function( newDefer ) {
                  jQuery.each( tuples, function( i, tuple ) {
                     var action = tuple[ 0 ],
                        fn = fns[ i ];
                     // deferred[ done | fail | progress ] for forwarding actions to newDefer
                     deferred[ tuple[1] ]( jQuery.isFunction( fn ) ?
                        function() {
                           var returned = fn.apply( this, arguments );
                           if ( returned && jQuery.isFunction( returned.promise ) ) {
                              returned.promise()
                                 .done( newDefer.resolve )
                                 .fail( newDefer.reject )
                                 .progress( newDefer.notify );
                           } else {
                              newDefer[ action + "With" ]( this === deferred ? newDefer : this, [ returned ] );
                           }
                        } :
                        newDefer[ action ]
                     );
                  });
                  fns = null;
               }).promise();
            },
            // Get a promise for this deferred
            // If obj is provided, the promise aspect is added to the object
            promise: function( obj ) {
               return obj != null ? jQuery.extend( obj, promise ) : promise;
            }
         },
         deferred = {};

      // Keep pipe for back-compat
      promise.pipe = promise.then;

      // Add list-specific methods
      jQuery.each( tuples, function( i, tuple ) {
         var list = tuple[ 2 ],
            stateString = tuple[ 3 ];

         // promise[ done | fail | progress ] = list.add
         promise[ tuple[1] ] = list.add;

         // Handle state
         if ( stateString ) {
            list.add(function() {
               // state = [ resolved | rejected ]
               state = stateString;

            // [ reject_list | resolve_list ].disable; progress_list.lock
            }, tuples[ i ^ 1 ][ 2 ].disable, tuples[ 2 ][ 2 ].lock );
         }

         // deferred[ resolve | reject | notify ] = list.fire
         deferred[ tuple[0] ] = list.fire;
         deferred[ tuple[0] + "With" ] = list.fireWith;
      });

      // Make the deferred a promise
      promise.promise( deferred );

      // Call given func if any
      if ( func ) {
         func.call( deferred, deferred );
      }

      // All done!
      return deferred;
   },

   // Deferred helper
   when: function( subordinate /* , ..., subordinateN */ ) {
      var i = 0,
         resolveValues = core_slice.call( arguments ),
         length = resolveValues.length,

         // the count of uncompleted subordinates
         remaining = length !== 1 || ( subordinate && jQuery.isFunction( subordinate.promise ) ) ? length : 0,

         // the master Deferred. If resolveValues consist of only a single Deferred, just use that.
         deferred = remaining === 1 ? subordinate : jQuery.Deferred(),

         // Update function for both resolve and progress values
         updateFunc = function( i, contexts, values ) {
            return function( value ) {
               contexts[ i ] = this;
               values[ i ] = arguments.length > 1 ? core_slice.call( arguments ) : value;
               if( values === progressValues ) {
                  deferred.notifyWith( contexts, values );
               } else if ( !( --remaining ) ) {
                  deferred.resolveWith( contexts, values );
               }
            };
         },

         progressValues, progressContexts, resolveContexts;

      // add listeners to Deferred subordinates; treat others as resolved
      if ( length > 1 ) {
         progressValues = new Array( length );
         progressContexts = new Array( length );
         resolveContexts = new Array( length );
         for ( ; i < length; i++ ) {
            if ( resolveValues[ i ] && jQuery.isFunction( resolveValues[ i ].promise ) ) {
               resolveValues[ i ].promise()
                  .done( updateFunc( i, resolveContexts, resolveValues ) )
                  .fail( deferred.reject )
                  .progress( updateFunc( i, progressContexts, progressValues ) );
            } else {
               --remaining;
            }
         }
      }

      // if we're not waiting on anything, resolve the master
      if ( !remaining ) {
         deferred.resolveWith( resolveContexts, resolveValues );
      }

      return deferred.promise();
   }
});
jQuery.support = (function() {

   var support,
      all,
      a,
      select,
      opt,
      input,
      fragment,
      eventName,
      i,
      isSupported,
      clickFn,
      div = document.createElement("div");

   // Preliminary tests
   div.setAttribute( "className", "t" );
   div.innerHTML = "  <link/><table></table><a href='/a'>a</a><input type='checkbox'/>";

   all = div.getElementsByTagName("*");
   a = div.getElementsByTagName("a")[ 0 ];
   a.style.cssText = "top:1px;float:left;opacity:.5";

   // Can't get basic test support
   if ( !all || !all.length ) {
      return {};
   }

   // First batch of supports tests
   select = document.createElement("select");
   opt = select.appendChild( document.createElement("option") );
   input = div.getElementsByTagName("input")[ 0 ];

   support = {
      // IE strips leading whitespace when .innerHTML is used
      leadingWhitespace: ( div.firstChild.nodeType === 3 ),

      // Make sure that tbody elements aren't automatically inserted
      // IE will insert them into empty tables
      tbody: !div.getElementsByTagName("tbody").length,

      // Make sure that link elements get serialized correctly by innerHTML
      // This requires a wrapper element in IE
      htmlSerialize: !!div.getElementsByTagName("link").length,

      // Get the style information from getAttribute
      // (IE uses .cssText instead)
      style: /top/.test( a.getAttribute("style") ),

      // Make sure that URLs aren't manipulated
      // (IE normalizes it by default)
      hrefNormalized: ( a.getAttribute("href") === "/a" ),

      // Make sure that element opacity exists
      // (IE uses filter instead)
      // Use a regex to work around a WebKit issue. See #5145
      opacity: /^0.5/.test( a.style.opacity ),

      // Verify style float existence
      // (IE uses styleFloat instead of cssFloat)
      cssFloat: !!a.style.cssFloat,

      // Make sure that if no value is specified for a checkbox
      // that it defaults to "on".
      // (WebKit defaults to "" instead)
      checkOn: ( input.value === "on" ),

      // Make sure that a selected-by-default option has a working selected property.
      // (WebKit defaults to false instead of true, IE too, if it's in an optgroup)
      optSelected: opt.selected,

      // Test setAttribute on camelCase class. If it works, we need attrFixes when doing get/setAttribute (ie6/7)
      getSetAttribute: div.className !== "t",

      // Tests for enctype support on a form(#6743)
      enctype: !!document.createElement("form").enctype,

      // Makes sure cloning an html5 element does not cause problems
      // Where outerHTML is undefined, this still works
      html5Clone: document.createElement("nav").cloneNode( true ).outerHTML !== "<:nav></:nav>",

      // jQuery.support.boxModel DEPRECATED in 1.8 since we don't support Quirks Mode
      boxModel: ( document.compatMode === "CSS1Compat" ),

      // Will be defined later
      submitBubbles: true,
      changeBubbles: true,
      focusinBubbles: false,
      deleteExpando: true,
      noCloneEvent: true,
      inlineBlockNeedsLayout: false,
      shrinkWrapBlocks: false,
      reliableMarginRight: true,
      boxSizingReliable: true,
      pixelPosition: false
   };

   // Make sure checked status is properly cloned
   input.checked = true;
   support.noCloneChecked = input.cloneNode( true ).checked;

   // Make sure that the options inside disabled selects aren't marked as disabled
   // (WebKit marks them as disabled)
   select.disabled = true;
   support.optDisabled = !opt.disabled;

   // Test to see if it's possible to delete an expando from an element
   // Fails in Internet Explorer
   try {
      delete div.test;
   } catch( e ) {
      support.deleteExpando = false;
   }

   if ( !div.addEventListener && div.attachEvent && div.fireEvent ) {
      div.attachEvent( "onclick", clickFn = function() {
         // Cloning a node shouldn't copy over any
         // bound event handlers (IE does this)
         support.noCloneEvent = false;
      });
      div.cloneNode( true ).fireEvent("onclick");
      div.detachEvent( "onclick", clickFn );
   }

   // Check if a radio maintains its value
   // after being appended to the DOM
   input = document.createElement("input");
   input.value = "t";
   input.setAttribute( "type", "radio" );
   support.radioValue = input.value === "t";

   input.setAttribute( "checked", "checked" );

   // #11217 - WebKit loses check when the name is after the checked attribute
   input.setAttribute( "name", "t" );

   div.appendChild( input );
   fragment = document.createDocumentFragment();
   fragment.appendChild( div.lastChild );

   // WebKit doesn't clone checked state correctly in fragments
   support.checkClone = fragment.cloneNode( true ).cloneNode( true ).lastChild.checked;

   // Check if a disconnected checkbox will retain its checked
   // value of true after appended to the DOM (IE6/7)
   support.appendChecked = input.checked;

   fragment.removeChild( input );
   fragment.appendChild( div );

   // Technique from Juriy Zaytsev
   // http://perfectionkills.com/detecting-event-support-without-browser-sniffing/
   // We only care about the case where non-standard event systems
   // are used, namely in IE. Short-circuiting here helps us to
   // avoid an eval call (in setAttribute) which can cause CSP
   // to go haywire. See: https://developer.mozilla.org/en/Security/CSP
   if ( div.attachEvent ) {
      for ( i in {
         submit: true,
         change: true,
         focusin: true
      }) {
         eventName = "on" + i;
         isSupported = ( eventName in div );
         if ( !isSupported ) {
            div.setAttribute( eventName, "return;" );
            isSupported = ( typeof div[ eventName ] === "function" );
         }
         support[ i + "Bubbles" ] = isSupported;
      }
   }

   // Run tests that need a body at doc ready
   jQuery(function() {
      var container, div, tds, marginDiv,
         divReset = "padding:0;margin:0;border:0;display:block;overflow:hidden;",
         body = document.getElementsByTagName("body")[0];

      if ( !body ) {
         // Return for frameset docs that don't have a body
         return;
      }

      container = document.createElement("div");
      container.style.cssText = "visibility:hidden;border:0;width:0;height:0;position:static;top:0;margin-top:1px";
      body.insertBefore( container, body.firstChild );

      // Construct the test element
      div = document.createElement("div");
      container.appendChild( div );

      // Check if table cells still have offsetWidth/Height when they are set
      // to display:none and there are still other visible table cells in a
      // table row; if so, offsetWidth/Height are not reliable for use when
      // determining if an element has been hidden directly using
      // display:none (it is still safe to use offsets if a parent element is
      // hidden; don safety goggles and see bug #4512 for more information).
      // (only IE 8 fails this test)
      div.innerHTML = "<table><tr><td></td><td>t</td></tr></table>";
      tds = div.getElementsByTagName("td");
      tds[ 0 ].style.cssText = "padding:0;margin:0;border:0;display:none";
      isSupported = ( tds[ 0 ].offsetHeight === 0 );

      tds[ 0 ].style.display = "";
      tds[ 1 ].style.display = "none";

      // Check if empty table cells still have offsetWidth/Height
      // (IE <= 8 fail this test)
      support.reliableHiddenOffsets = isSupported && ( tds[ 0 ].offsetHeight === 0 );

      // Check box-sizing and margin behavior
      div.innerHTML = "";
      div.style.cssText = "box-sizing:border-box;-moz-box-sizing:border-box;-webkit-box-sizing:border-box;padding:1px;border:1px;display:block;width:4px;margin-top:1%;position:absolute;top:1%;";
      support.boxSizing = ( div.offsetWidth === 4 );
      support.doesNotIncludeMarginInBodyOffset = ( body.offsetTop !== 1 );

      // NOTE: To any future maintainer, we've window.getComputedStyle
      // because jsdom on node.js will break without it.
      if ( window.getComputedStyle ) {
         support.pixelPosition = ( window.getComputedStyle( div, null ) || {} ).top !== "1%";
         support.boxSizingReliable = ( window.getComputedStyle( div, null ) || { width: "4px" } ).width === "4px";

         // Check if div with explicit width and no margin-right incorrectly
         // gets computed margin-right based on width of container. For more
         // info see bug #3333
         // Fails in WebKit before Feb 2011 nightlies
         // WebKit Bug 13343 - getComputedStyle returns wrong value for margin-right
         marginDiv = document.createElement("div");
         marginDiv.style.cssText = div.style.cssText = divReset;
         marginDiv.style.marginRight = marginDiv.style.width = "0";
         div.style.width = "1px";
         div.appendChild( marginDiv );
         support.reliableMarginRight =
            !parseFloat( ( window.getComputedStyle( marginDiv, null ) || {} ).marginRight );
      }

      if ( typeof div.style.zoom !== "undefined" ) {
         // Check if natively block-level elements act like inline-block
         // elements when setting their display to 'inline' and giving
         // them layout
         // (IE < 8 does this)
         div.innerHTML = "";
         div.style.cssText = divReset + "width:1px;padding:1px;display:inline;zoom:1";
         support.inlineBlockNeedsLayout = ( div.offsetWidth === 3 );

         // Check if elements with layout shrink-wrap their children
         // (IE 6 does this)
         div.style.display = "block";
         div.style.overflow = "visible";
         div.innerHTML = "<div></div>";
         div.firstChild.style.width = "5px";
         support.shrinkWrapBlocks = ( div.offsetWidth !== 3 );

         container.style.zoom = 1;
      }

      // Null elements to avoid leaks in IE
      body.removeChild( container );
      container = div = tds = marginDiv = null;
   });

   // Null elements to avoid leaks in IE
   fragment.removeChild( div );
   all = a = select = opt = input = fragment = div = null;

   return support;
})();
var rbrace = /(?:\{[\s\S]*\}|\[[\s\S]*\])$/,
   rmultiDash = /([A-Z])/g;

jQuery.extend({
   cache: {},

   deletedIds: [],

   // Remove at next major release (1.9/2.0)
   uuid: 0,

   // Unique for each copy of jQuery on the page
   // Non-digits removed to match rinlinejQuery
   expando: "jQuery" + ( jQuery.fn.jquery + Math.random() ).replace( /\D/g, "" ),

   // The following elements throw uncatchable exceptions if you
   // attempt to add expando properties to them.
   noData: {
      "embed": true,
      // Ban all objects except for Flash (which handle expandos)
      "object": "clsid:D27CDB6E-AE6D-11cf-96B8-444553540000",
      "applet": true
   },

   hasData: function( elem ) {
      elem = elem.nodeType ? jQuery.cache[ elem[jQuery.expando] ] : elem[ jQuery.expando ];
      return !!elem && !isEmptyDataObject( elem );
   },

   data: function( elem, name, data, pvt /* Internal Use Only */ ) {
      if ( !jQuery.acceptData( elem ) ) {
         return;
      }

      var thisCache, ret,
         internalKey = jQuery.expando,
         getByName = typeof name === "string",

         // We have to handle DOM nodes and JS objects differently because IE6-7
         // can't GC object references properly across the DOM-JS boundary
         isNode = elem.nodeType,

         // Only DOM nodes need the global jQuery cache; JS object data is
         // attached directly to the object so GC can occur automatically
         cache = isNode ? jQuery.cache : elem,

         // Only defining an ID for JS objects if its cache already exists allows
         // the code to shortcut on the same path as a DOM node with no cache
         id = isNode ? elem[ internalKey ] : elem[ internalKey ] && internalKey;

      // Avoid doing any more work than we need to when trying to get data on an
      // object that has no data at all
      if ( (!id || !cache[id] || (!pvt && !cache[id].data)) && getByName && data === undefined ) {
         return;
      }

      if ( !id ) {
         // Only DOM nodes need a new unique ID for each element since their data
         // ends up in the global cache
         if ( isNode ) {
            elem[ internalKey ] = id = jQuery.deletedIds.pop() || jQuery.guid++;
         } else {
            id = internalKey;
         }
      }

      if ( !cache[ id ] ) {
         cache[ id ] = {};

         // Avoids exposing jQuery metadata on plain JS objects when the object
         // is serialized using JSON.stringify
         if ( !isNode ) {
            cache[ id ].toJSON = jQuery.noop;
         }
      }

      // An object can be passed to jQuery.data instead of a key/value pair; this gets
      // shallow copied over onto the existing cache
      if ( typeof name === "object" || typeof name === "function" ) {
         if ( pvt ) {
            cache[ id ] = jQuery.extend( cache[ id ], name );
         } else {
            cache[ id ].data = jQuery.extend( cache[ id ].data, name );
         }
      }

      thisCache = cache[ id ];

      // jQuery data() is stored in a separate object inside the object's internal data
      // cache in order to avoid key collisions between internal data and user-defined
      // data.
      if ( !pvt ) {
         if ( !thisCache.data ) {
            thisCache.data = {};
         }

         thisCache = thisCache.data;
      }

      if ( data !== undefined ) {
         thisCache[ jQuery.camelCase( name ) ] = data;
      }

      // Check for both converted-to-camel and non-converted data property names
      // If a data property was specified
      if ( getByName ) {

         // First Try to find as-is property data
         ret = thisCache[ name ];

         // Test for null|undefined property data
         if ( ret == null ) {

            // Try to find the camelCased property
            ret = thisCache[ jQuery.camelCase( name ) ];
         }
      } else {
         ret = thisCache;
      }

      return ret;
   },

   removeData: function( elem, name, pvt /* Internal Use Only */ ) {
      if ( !jQuery.acceptData( elem ) ) {
         return;
      }

      var thisCache, i, l,

         isNode = elem.nodeType,

         // See jQuery.data for more information
         cache = isNode ? jQuery.cache : elem,
         id = isNode ? elem[ jQuery.expando ] : jQuery.expando;

      // If there is already no cache entry for this object, there is no
      // purpose in continuing
      if ( !cache[ id ] ) {
         return;
      }

      if ( name ) {

         thisCache = pvt ? cache[ id ] : cache[ id ].data;

         if ( thisCache ) {

            // Support array or space separated string names for data keys
            if ( !jQuery.isArray( name ) ) {

               // try the string as a key before any manipulation
               if ( name in thisCache ) {
                  name = [ name ];
               } else {

                  // split the camel cased version by spaces unless a key with the spaces exists
                  name = jQuery.camelCase( name );
                  if ( name in thisCache ) {
                     name = [ name ];
                  } else {
                     name = name.split(" ");
                  }
               }
            }

            for ( i = 0, l = name.length; i < l; i++ ) {
               delete thisCache[ name[i] ];
            }

            // If there is no data left in the cache, we want to continue
            // and let the cache object itself get destroyed
            if ( !( pvt ? isEmptyDataObject : jQuery.isEmptyObject )( thisCache ) ) {
               return;
            }
         }
      }

      // See jQuery.data for more information
      if ( !pvt ) {
         delete cache[ id ].data;

         // Don't destroy the parent cache unless the internal data object
         // had been the only thing left in it
         if ( !isEmptyDataObject( cache[ id ] ) ) {
            return;
         }
      }

      // Destroy the cache
      if ( isNode ) {
         jQuery.cleanData( [ elem ], true );

      // Use delete when supported for expandos or `cache` is not a window per isWindow (#10080)
      } else if ( jQuery.support.deleteExpando || cache != cache.window ) {
         delete cache[ id ];

      // When all else fails, null
      } else {
         cache[ id ] = null;
      }
   },

   // For internal use only.
   _data: function( elem, name, data ) {
      return jQuery.data( elem, name, data, true );
   },

   // A method for determining if a DOM node can handle the data expando
   acceptData: function( elem ) {
      var noData = elem.nodeName && jQuery.noData[ elem.nodeName.toLowerCase() ];

      // nodes accept data unless otherwise specified; rejection can be conditional
      return !noData || noData !== true && elem.getAttribute("classid") === noData;
   }
});

jQuery.fn.extend({
   data: function( key, value ) {
      var parts, part, attr, name, l,
         elem = this[0],
         i = 0,
         data = null;

      // Gets all values
      if ( key === undefined ) {
         if ( this.length ) {
            data = jQuery.data( elem );

            if ( elem.nodeType === 1 && !jQuery._data( elem, "parsedAttrs" ) ) {
               attr = elem.attributes;
               for ( l = attr.length; i < l; i++ ) {
                  name = attr[i].name;

                  if ( !name.indexOf( "data-" ) ) {
                     name = jQuery.camelCase( name.substring(5) );

                     dataAttr( elem, name, data[ name ] );
                  }
               }
               jQuery._data( elem, "parsedAttrs", true );
            }
         }

         return data;
      }

      // Sets multiple values
      if ( typeof key === "object" ) {
         return this.each(function() {
            jQuery.data( this, key );
         });
      }

      parts = key.split( ".", 2 );
      parts[1] = parts[1] ? "." + parts[1] : "";
      part = parts[1] + "!";

      return jQuery.access( this, function( value ) {

         if ( value === undefined ) {
            data = this.triggerHandler( "getData" + part, [ parts[0] ] );

            // Try to fetch any internally stored data first
            if ( data === undefined && elem ) {
               data = jQuery.data( elem, key );
               data = dataAttr( elem, key, data );
            }

            return data === undefined && parts[1] ?
               this.data( parts[0] ) :
               data;
         }

         parts[1] = value;
         this.each(function() {
            var self = jQuery( this );

            self.triggerHandler( "setData" + part, parts );
            jQuery.data( this, key, value );
            self.triggerHandler( "changeData" + part, parts );
         });
      }, null, value, arguments.length > 1, null, false );
   },

   removeData: function( key ) {
      return this.each(function() {
         jQuery.removeData( this, key );
      });
   }
});

function dataAttr( elem, key, data ) {
   // If nothing was found internally, try to fetch any
   // data from the HTML5 data-* attribute
   if ( data === undefined && elem.nodeType === 1 ) {

      var name = "data-" + key.replace( rmultiDash, "-$1" ).toLowerCase();

      data = elem.getAttribute( name );

      if ( typeof data === "string" ) {
         try {
            data = data === "true" ? true :
            data === "false" ? false :
            data === "null" ? null :
            // Only convert to a number if it doesn't change the string
            +data + "" === data ? +data :
            rbrace.test( data ) ? jQuery.parseJSON( data ) :
               data;
         } catch( e ) {}

         // Make sure we set the data so it isn't changed later
         jQuery.data( elem, key, data );

      } else {
         data = undefined;
      }
   }

   return data;
}

// checks a cache object for emptiness
function isEmptyDataObject( obj ) {
   var name;
   for ( name in obj ) {

      // if the public data object is empty, the private is still empty
      if ( name === "data" && jQuery.isEmptyObject( obj[name] ) ) {
         continue;
      }
      if ( name !== "toJSON" ) {
         return false;
      }
   }

   return true;
}
jQuery.extend({
   queue: function( elem, type, data ) {
      var queue;

      if ( elem ) {
         type = ( type || "fx" ) + "queue";
         queue = jQuery._data( elem, type );

         // Speed up dequeue by getting out quickly if this is just a lookup
         if ( data ) {
            if ( !queue || jQuery.isArray(data) ) {
               queue = jQuery._data( elem, type, jQuery.makeArray(data) );
            } else {
               queue.push( data );
            }
         }
         return queue || [];
      }
   },

   dequeue: function( elem, type ) {
      type = type || "fx";

      var queue = jQuery.queue( elem, type ),
         startLength = queue.length,
         fn = queue.shift(),
         hooks = jQuery._queueHooks( elem, type ),
         next = function() {
            jQuery.dequeue( elem, type );
         };

      // If the fx queue is dequeued, always remove the progress sentinel
      if ( fn === "inprogress" ) {
         fn = queue.shift();
         startLength--;
      }

      if ( fn ) {

         // Add a progress sentinel to prevent the fx queue from being
         // automatically dequeued
         if ( type === "fx" ) {
            queue.unshift( "inprogress" );
         }

         // clear up the last queue stop function
         delete hooks.stop;
         fn.call( elem, next, hooks );
      }

      if ( !startLength && hooks ) {
         hooks.empty.fire();
      }
   },

   // not intended for public consumption - generates a queueHooks object, or returns the current one
   _queueHooks: function( elem, type ) {
      var key = type + "queueHooks";
      return jQuery._data( elem, key ) || jQuery._data( elem, key, {
         empty: jQuery.Callbacks("once memory").add(function() {
            jQuery.removeData( elem, type + "queue", true );
            jQuery.removeData( elem, key, true );
         })
      });
   }
});

jQuery.fn.extend({
   queue: function( type, data ) {
      var setter = 2;

      if ( typeof type !== "string" ) {
         data = type;
         type = "fx";
         setter--;
      }

      if ( arguments.length < setter ) {
         return jQuery.queue( this[0], type );
      }

      return data === undefined ?
         this :
         this.each(function() {
            var queue = jQuery.queue( this, type, data );

            // ensure a hooks for this queue
            jQuery._queueHooks( this, type );

            if ( type === "fx" && queue[0] !== "inprogress" ) {
               jQuery.dequeue( this, type );
            }
         });
   },
   dequeue: function( type ) {
      return this.each(function() {
         jQuery.dequeue( this, type );
      });
   },
   // Based off of the plugin by Clint Helfers, with permission.
   // http://blindsignals.com/index.php/2009/07/jquery-delay/
   delay: function( time, type ) {
      time = jQuery.fx ? jQuery.fx.speeds[ time ] || time : time;
      type = type || "fx";

      return this.queue( type, function( next, hooks ) {
         var timeout = setTimeout( next, time );
         hooks.stop = function() {
            clearTimeout( timeout );
         };
      });
   },
   clearQueue: function( type ) {
      return this.queue( type || "fx", [] );
   },
   // Get a promise resolved when queues of a certain type
   // are emptied (fx is the type by default)
   promise: function( type, obj ) {
      var tmp,
         count = 1,
         defer = jQuery.Deferred(),
         elements = this,
         i = this.length,
         resolve = function() {
            if ( !( --count ) ) {
               defer.resolveWith( elements, [ elements ] );
            }
         };

      if ( typeof type !== "string" ) {
         obj = type;
         type = undefined;
      }
      type = type || "fx";

      while( i-- ) {
         tmp = jQuery._data( elements[ i ], type + "queueHooks" );
         if ( tmp && tmp.empty ) {
            count++;
            tmp.empty.add( resolve );
         }
      }
      resolve();
      return defer.promise( obj );
   }
});
var nodeHook, boolHook, fixSpecified,
   rclass = /[\t\r\n]/g,
   rreturn = /\r/g,
   rtype = /^(?:button|input)$/i,
   rfocusable = /^(?:button|input|object|select|textarea)$/i,
   rclickable = /^a(?:rea|)$/i,
   rboolean = /^(?:autofocus|autoplay|async|checked|controls|defer|disabled|hidden|loop|multiple|open|readonly|required|scoped|selected)$/i,
   getSetAttribute = jQuery.support.getSetAttribute;

jQuery.fn.extend({
   attr: function( name, value ) {
      return jQuery.access( this, jQuery.attr, name, value, arguments.length > 1 );
   },

   removeAttr: function( name ) {
      return this.each(function() {
         jQuery.removeAttr( this, name );
      });
   },

   prop: function( name, value ) {
      return jQuery.access( this, jQuery.prop, name, value, arguments.length > 1 );
   },

   removeProp: function( name ) {
      name = jQuery.propFix[ name ] || name;
      return this.each(function() {
         // try/catch handles cases where IE balks (such as removing a property on window)
         try {
            this[ name ] = undefined;
            delete this[ name ];
         } catch( e ) {}
      });
   },

   addClass: function( value ) {
      var classNames, i, l, elem,
         setClass, c, cl;

      if ( jQuery.isFunction( value ) ) {
         return this.each(function( j ) {
            jQuery( this ).addClass( value.call(this, j, this.className) );
         });
      }

      if ( value && typeof value === "string" ) {
         classNames = value.split( core_rspace );

         for ( i = 0, l = this.length; i < l; i++ ) {
            elem = this[ i ];

            if ( elem.nodeType === 1 ) {
               if ( !elem.className && classNames.length === 1 ) {
                  elem.className = value;

               } else {
                  setClass = " " + elem.className + " ";

                  for ( c = 0, cl = classNames.length; c < cl; c++ ) {
                     if ( setClass.indexOf( " " + classNames[ c ] + " " ) < 0 ) {
                        setClass += classNames[ c ] + " ";
                     }
                  }
                  elem.className = jQuery.trim( setClass );
               }
            }
         }
      }

      return this;
   },

   removeClass: function( value ) {
      var removes, className, elem, c, cl, i, l;

      if ( jQuery.isFunction( value ) ) {
         return this.each(function( j ) {
            jQuery( this ).removeClass( value.call(this, j, this.className) );
         });
      }
      if ( (value && typeof value === "string") || value === undefined ) {
         removes = ( value || "" ).split( core_rspace );

         for ( i = 0, l = this.length; i < l; i++ ) {
            elem = this[ i ];
            if ( elem.nodeType === 1 && elem.className ) {

               className = (" " + elem.className + " ").replace( rclass, " " );

               // loop over each item in the removal list
               for ( c = 0, cl = removes.length; c < cl; c++ ) {
                  // Remove until there is nothing to remove,
                  while ( className.indexOf(" " + removes[ c ] + " ") >= 0 ) {
                     className = className.replace( " " + removes[ c ] + " " , " " );
                  }
               }
               elem.className = value ? jQuery.trim( className ) : "";
            }
         }
      }

      return this;
   },

   toggleClass: function( value, stateVal ) {
      var type = typeof value,
         isBool = typeof stateVal === "boolean";

      if ( jQuery.isFunction( value ) ) {
         return this.each(function( i ) {
            jQuery( this ).toggleClass( value.call(this, i, this.className, stateVal), stateVal );
         });
      }

      return this.each(function() {
         if ( type === "string" ) {
            // toggle individual class names
            var className,
               i = 0,
               self = jQuery( this ),
               state = stateVal,
               classNames = value.split( core_rspace );

            while ( (className = classNames[ i++ ]) ) {
               // check each className given, space separated list
               state = isBool ? state : !self.hasClass( className );
               self[ state ? "addClass" : "removeClass" ]( className );
            }

         } else if ( type === "undefined" || type === "boolean" ) {
            if ( this.className ) {
               // store className if set
               jQuery._data( this, "__className__", this.className );
            }

            // toggle whole className
            this.className = this.className || value === false ? "" : jQuery._data( this, "__className__" ) || "";
         }
      });
   },

   hasClass: function( selector ) {
      var className = " " + selector + " ",
         i = 0,
         l = this.length;
      for ( ; i < l; i++ ) {
         if ( this[i].nodeType === 1 && (" " + this[i].className + " ").replace(rclass, " ").indexOf( className ) >= 0 ) {
            return true;
         }
      }

      return false;
   },

   val: function( value ) {
      var hooks, ret, isFunction,
         elem = this[0];

      if ( !arguments.length ) {
         if ( elem ) {
            hooks = jQuery.valHooks[ elem.type ] || jQuery.valHooks[ elem.nodeName.toLowerCase() ];

            if ( hooks && "get" in hooks && (ret = hooks.get( elem, "value" )) !== undefined ) {
               return ret;
            }

            ret = elem.value;

            return typeof ret === "string" ?
               // handle most common string cases
               ret.replace(rreturn, "") :
               // handle cases where value is null/undef or number
               ret == null ? "" : ret;
         }

         return;
      }

      isFunction = jQuery.isFunction( value );

      return this.each(function( i ) {
         var val,
            self = jQuery(this);

         if ( this.nodeType !== 1 ) {
            return;
         }

         if ( isFunction ) {
            val = value.call( this, i, self.val() );
         } else {
            val = value;
         }

         // Treat null/undefined as ""; convert numbers to string
         if ( val == null ) {
            val = "";
         } else if ( typeof val === "number" ) {
            val += "";
         } else if ( jQuery.isArray( val ) ) {
            val = jQuery.map(val, function ( value ) {
               return value == null ? "" : value + "";
            });
         }

         hooks = jQuery.valHooks[ this.type ] || jQuery.valHooks[ this.nodeName.toLowerCase() ];

         // If set returns undefined, fall back to normal setting
         if ( !hooks || !("set" in hooks) || hooks.set( this, val, "value" ) === undefined ) {
            this.value = val;
         }
      });
   }
});

jQuery.extend({
   valHooks: {
      option: {
         get: function( elem ) {
            // attributes.value is undefined in Blackberry 4.7 but
            // uses .value. See #6932
            var val = elem.attributes.value;
            return !val || val.specified ? elem.value : elem.text;
         }
      },
      select: {
         get: function( elem ) {
            var value, i, max, option,
               index = elem.selectedIndex,
               values = [],
               options = elem.options,
               one = elem.type === "select-one";

            // Nothing was selected
            if ( index < 0 ) {
               return null;
            }

            // Loop through all the selected options
            i = one ? index : 0;
            max = one ? index + 1 : options.length;
            for ( ; i < max; i++ ) {
               option = options[ i ];

               // Don't return options that are disabled or in a disabled optgroup
               if ( option.selected && (jQuery.support.optDisabled ? !option.disabled : option.getAttribute("disabled") === null) &&
                     (!option.parentNode.disabled || !jQuery.nodeName( option.parentNode, "optgroup" )) ) {

                  // Get the specific value for the option
                  value = jQuery( option ).val();

                  // We don't need an array for one selects
                  if ( one ) {
                     return value;
                  }

                  // Multi-Selects return an array
                  values.push( value );
               }
            }

            // Fixes Bug #2551 -- select.val() broken in IE after form.reset()
            if ( one && !values.length && options.length ) {
               return jQuery( options[ index ] ).val();
            }

            return values;
         },

         set: function( elem, value ) {
            var values = jQuery.makeArray( value );

            jQuery(elem).find("option").each(function() {
               this.selected = jQuery.inArray( jQuery(this).val(), values ) >= 0;
            });

            if ( !values.length ) {
               elem.selectedIndex = -1;
            }
            return values;
         }
      }
   },

   // Unused in 1.8, left in so attrFn-stabbers won't die; remove in 1.9
   attrFn: {},

   attr: function( elem, name, value, pass ) {
      var ret, hooks, notxml,
         nType = elem.nodeType;

      // don't get/set attributes on text, comment and attribute nodes
      if ( !elem || nType === 3 || nType === 8 || nType === 2 ) {
         return;
      }

      if ( pass && jQuery.isFunction( jQuery.fn[ name ] ) ) {
         return jQuery( elem )[ name ]( value );
      }

      // Fallback to prop when attributes are not supported
      if ( typeof elem.getAttribute === "undefined" ) {
         return jQuery.prop( elem, name, value );
      }

      notxml = nType !== 1 || !jQuery.isXMLDoc( elem );

      // All attributes are lowercase
      // Grab necessary hook if one is defined
      if ( notxml ) {
         name = name.toLowerCase();
         hooks = jQuery.attrHooks[ name ] || ( rboolean.test( name ) ? boolHook : nodeHook );
      }

      if ( value !== undefined ) {

         if ( value === null ) {
            jQuery.removeAttr( elem, name );
            return;

         } else if ( hooks && "set" in hooks && notxml && (ret = hooks.set( elem, value, name )) !== undefined ) {
            return ret;

         } else {
            elem.setAttribute( name, value + "" );
            return value;
         }

      } else if ( hooks && "get" in hooks && notxml && (ret = hooks.get( elem, name )) !== null ) {
         return ret;

      } else {

         ret = elem.getAttribute( name );

         // Non-existent attributes return null, we normalize to undefined
         return ret === null ?
            undefined :
            ret;
      }
   },

   removeAttr: function( elem, value ) {
      var propName, attrNames, name, isBool,
         i = 0;

      if ( value && elem.nodeType === 1 ) {

         attrNames = value.split( core_rspace );

         for ( ; i < attrNames.length; i++ ) {
            name = attrNames[ i ];

            if ( name ) {
               propName = jQuery.propFix[ name ] || name;
               isBool = rboolean.test( name );

               // See #9699 for explanation of this approach (setting first, then removal)
               // Do not do this for boolean attributes (see #10870)
               if ( !isBool ) {
                  jQuery.attr( elem, name, "" );
               }
               elem.removeAttribute( getSetAttribute ? name : propName );

               // Set corresponding property to false for boolean attributes
               if ( isBool && propName in elem ) {
                  elem[ propName ] = false;
               }
            }
         }
      }
   },

   attrHooks: {
      type: {
         set: function( elem, value ) {
            // We can't allow the type property to be changed (since it causes problems in IE)
            if ( rtype.test( elem.nodeName ) && elem.parentNode ) {
               jQuery.error( "type property can't be changed" );
            } else if ( !jQuery.support.radioValue && value === "radio" && jQuery.nodeName(elem, "input") ) {
               // Setting the type on a radio button after the value resets the value in IE6-9
               // Reset value to it's default in case type is set after value
               // This is for element creation
               var val = elem.value;
               elem.setAttribute( "type", value );
               if ( val ) {
                  elem.value = val;
               }
               return value;
            }
         }
      },
      // Use the value property for back compat
      // Use the nodeHook for button elements in IE6/7 (#1954)
      value: {
         get: function( elem, name ) {
            if ( nodeHook && jQuery.nodeName( elem, "button" ) ) {
               return nodeHook.get( elem, name );
            }
            return name in elem ?
               elem.value :
               null;
         },
         set: function( elem, value, name ) {
            if ( nodeHook && jQuery.nodeName( elem, "button" ) ) {
               return nodeHook.set( elem, value, name );
            }
            // Does not return so that setAttribute is also used
            elem.value = value;
         }
      }
   },

   propFix: {
      tabindex: "tabIndex",
      readonly: "readOnly",
      "for": "htmlFor",
      "class": "className",
      maxlength: "maxLength",
      cellspacing: "cellSpacing",
      cellpadding: "cellPadding",
      rowspan: "rowSpan",
      colspan: "colSpan",
      usemap: "useMap",
      frameborder: "frameBorder",
      contenteditable: "contentEditable"
   },

   prop: function( elem, name, value ) {
      var ret, hooks, notxml,
         nType = elem.nodeType;

      // don't get/set properties on text, comment and attribute nodes
      if ( !elem || nType === 3 || nType === 8 || nType === 2 ) {
         return;
      }

      notxml = nType !== 1 || !jQuery.isXMLDoc( elem );

      if ( notxml ) {
         // Fix name and attach hooks
         name = jQuery.propFix[ name ] || name;
         hooks = jQuery.propHooks[ name ];
      }

      if ( value !== undefined ) {
         if ( hooks && "set" in hooks && (ret = hooks.set( elem, value, name )) !== undefined ) {
            return ret;

         } else {
            return ( elem[ name ] = value );
         }

      } else {
         if ( hooks && "get" in hooks && (ret = hooks.get( elem, name )) !== null ) {
            return ret;

         } else {
            return elem[ name ];
         }
      }
   },

   propHooks: {
      tabIndex: {
         get: function( elem ) {
            // elem.tabIndex doesn't always return the correct value when it hasn't been explicitly set
            // http://fluidproject.org/blog/2008/01/09/getting-setting-and-removing-tabindex-values-with-javascript/
            var attributeNode = elem.getAttributeNode("tabindex");

            return attributeNode && attributeNode.specified ?
               parseInt( attributeNode.value, 10 ) :
               rfocusable.test( elem.nodeName ) || rclickable.test( elem.nodeName ) && elem.href ?
                  0 :
                  undefined;
         }
      }
   }
});

// Hook for boolean attributes
boolHook = {
   get: function( elem, name ) {
      // Align boolean attributes with corresponding properties
      // Fall back to attribute presence where some booleans are not supported
      var attrNode,
         property = jQuery.prop( elem, name );
      return property === true || typeof property !== "boolean" && ( attrNode = elem.getAttributeNode(name) ) && attrNode.nodeValue !== false ?
         name.toLowerCase() :
         undefined;
   },
   set: function( elem, value, name ) {
      var propName;
      if ( value === false ) {
         // Remove boolean attributes when set to false
         jQuery.removeAttr( elem, name );
      } else {
         // value is true since we know at this point it's type boolean and not false
         // Set boolean attributes to the same name and set the DOM property
         propName = jQuery.propFix[ name ] || name;
         if ( propName in elem ) {
            // Only set the IDL specifically if it already exists on the element
            elem[ propName ] = true;
         }

         elem.setAttribute( name, name.toLowerCase() );
      }
      return name;
   }
};

// IE6/7 do not support getting/setting some attributes with get/setAttribute
if ( !getSetAttribute ) {

   fixSpecified = {
      name: true,
      id: true,
      coords: true
   };

   // Use this for any attribute in IE6/7
   // This fixes almost every IE6/7 issue
   nodeHook = jQuery.valHooks.button = {
      get: function( elem, name ) {
         var ret;
         ret = elem.getAttributeNode( name );
         return ret && ( fixSpecified[ name ] ? ret.value !== "" : ret.specified ) ?
            ret.value :
            undefined;
      },
      set: function( elem, value, name ) {
         // Set the existing or create a new attribute node
         var ret = elem.getAttributeNode( name );
         if ( !ret ) {
            ret = document.createAttribute( name );
            elem.setAttributeNode( ret );
         }
         return ( ret.value = value + "" );
      }
   };

   // Set width and height to auto instead of 0 on empty string( Bug #8150 )
   // This is for removals
   jQuery.each([ "width", "height" ], function( i, name ) {
      jQuery.attrHooks[ name ] = jQuery.extend( jQuery.attrHooks[ name ], {
         set: function( elem, value ) {
            if ( value === "" ) {
               elem.setAttribute( name, "auto" );
               return value;
            }
         }
      });
   });

   // Set contenteditable to false on removals(#10429)
   // Setting to empty string throws an error as an invalid value
   jQuery.attrHooks.contenteditable = {
      get: nodeHook.get,
      set: function( elem, value, name ) {
         if ( value === "" ) {
            value = "false";
         }
         nodeHook.set( elem, value, name );
      }
   };
}


// Some attributes require a special call on IE
if ( !jQuery.support.hrefNormalized ) {
   jQuery.each([ "href", "src", "width", "height" ], function( i, name ) {
      jQuery.attrHooks[ name ] = jQuery.extend( jQuery.attrHooks[ name ], {
         get: function( elem ) {
            var ret = elem.getAttribute( name, 2 );
            return ret === null ? undefined : ret;
         }
      });
   });
}

if ( !jQuery.support.style ) {
   jQuery.attrHooks.style = {
      get: function( elem ) {
         // Return undefined in the case of empty string
         // Normalize to lowercase since IE uppercases css property names
         return elem.style.cssText.toLowerCase() || undefined;
      },
      set: function( elem, value ) {
         return ( elem.style.cssText = value + "" );
      }
   };
}

// Safari mis-reports the default selected property of an option
// Accessing the parent's selectedIndex property fixes it
if ( !jQuery.support.optSelected ) {
   jQuery.propHooks.selected = jQuery.extend( jQuery.propHooks.selected, {
      get: function( elem ) {
         var parent = elem.parentNode;

         if ( parent ) {
            parent.selectedIndex;

            // Make sure that it also works with optgroups, see #5701
            if ( parent.parentNode ) {
               parent.parentNode.selectedIndex;
            }
         }
         return null;
      }
   });
}

// IE6/7 call enctype encoding
if ( !jQuery.support.enctype ) {
   jQuery.propFix.enctype = "encoding";
}

// Radios and checkboxes getter/setter
if ( !jQuery.support.checkOn ) {
   jQuery.each([ "radio", "checkbox" ], function() {
      jQuery.valHooks[ this ] = {
         get: function( elem ) {
            // Handle the case where in Webkit "" is returned instead of "on" if a value isn't specified
            return elem.getAttribute("value") === null ? "on" : elem.value;
         }
      };
   });
}
jQuery.each([ "radio", "checkbox" ], function() {
   jQuery.valHooks[ this ] = jQuery.extend( jQuery.valHooks[ this ], {
      set: function( elem, value ) {
         if ( jQuery.isArray( value ) ) {
            return ( elem.checked = jQuery.inArray( jQuery(elem).val(), value ) >= 0 );
         }
      }
   });
});
var rformElems = /^(?:textarea|input|select)$/i,
   rtypenamespace = /^([^\.]*|)(?:\.(.+)|)$/,
   rhoverHack = /(?:^|\s)hover(\.\S+|)\b/,
   rkeyEvent = /^key/,
   rmouseEvent = /^(?:mouse|contextmenu)|click/,
   rfocusMorph = /^(?:focusinfocus|focusoutblur)$/,
   hoverHack = function( events ) {
      return jQuery.event.special.hover ? events : events.replace( rhoverHack, "mouseenter$1 mouseleave$1" );
   };

/*
 * Helper functions for managing events -- not part of the public interface.
 * Props to Dean Edwards' addEvent library for many of the ideas.
 */
jQuery.event = {

   add: function( elem, types, handler, data, selector ) {

      var elemData, eventHandle, events,
         t, tns, type, namespaces, handleObj,
         handleObjIn, handlers, special;

      // Don't attach events to noData or text/comment nodes (allow plain objects tho)
      if ( elem.nodeType === 3 || elem.nodeType === 8 || !types || !handler || !(elemData = jQuery._data( elem )) ) {
         return;
      }

      // Caller can pass in an object of custom data in lieu of the handler
      if ( handler.handler ) {
         handleObjIn = handler;
         handler = handleObjIn.handler;
         selector = handleObjIn.selector;
      }

      // Make sure that the handler has a unique ID, used to find/remove it later
      if ( !handler.guid ) {
         handler.guid = jQuery.guid++;
      }

      // Init the element's event structure and main handler, if this is the first
      events = elemData.events;
      if ( !events ) {
         elemData.events = events = {};
      }
      eventHandle = elemData.handle;
      if ( !eventHandle ) {
         elemData.handle = eventHandle = function( e ) {
            // Discard the second event of a jQuery.event.trigger() and
            // when an event is called after a page has unloaded
            return typeof jQuery !== "undefined" && (!e || jQuery.event.triggered !== e.type) ?
               jQuery.event.dispatch.apply( eventHandle.elem, arguments ) :
               undefined;
         };
         // Add elem as a property of the handle fn to prevent a memory leak with IE non-native events
         eventHandle.elem = elem;
      }

      // Handle multiple events separated by a space
      // jQuery(...).bind("mouseover mouseout", fn);
      types = jQuery.trim( hoverHack(types) ).split( " " );
      for ( t = 0; t < types.length; t++ ) {

         tns = rtypenamespace.exec( types[t] ) || [];
         type = tns[1];
         namespaces = ( tns[2] || "" ).split( "." ).sort();

         // If event changes its type, use the special event handlers for the changed type
         special = jQuery.event.special[ type ] || {};

         // If selector defined, determine special event api type, otherwise given type
         type = ( selector ? special.delegateType : special.bindType ) || type;

         // Update special based on newly reset type
         special = jQuery.event.special[ type ] || {};

         // handleObj is passed to all event handlers
         handleObj = jQuery.extend({
            type: type,
            origType: tns[1],
            data: data,
            handler: handler,
            guid: handler.guid,
            selector: selector,
            needsContext: selector && jQuery.expr.match.needsContext.test( selector ),
            namespace: namespaces.join(".")
         }, handleObjIn );

         // Init the event handler queue if we're the first
         handlers = events[ type ];
         if ( !handlers ) {
            handlers = events[ type ] = [];
            handlers.delegateCount = 0;

            // Only use addEventListener/attachEvent if the special events handler returns false
            if ( !special.setup || special.setup.call( elem, data, namespaces, eventHandle ) === false ) {
               // Bind the global event handler to the element
               if ( elem.addEventListener ) {
                  elem.addEventListener( type, eventHandle, false );

               } else if ( elem.attachEvent ) {
                  elem.attachEvent( "on" + type, eventHandle );
               }
            }
         }

         if ( special.add ) {
            special.add.call( elem, handleObj );

            if ( !handleObj.handler.guid ) {
               handleObj.handler.guid = handler.guid;
            }
         }

         // Add to the element's handler list, delegates in front
         if ( selector ) {
            handlers.splice( handlers.delegateCount++, 0, handleObj );
         } else {
            handlers.push( handleObj );
         }

         // Keep track of which events have ever been used, for event optimization
         jQuery.event.global[ type ] = true;
      }

      // Nullify elem to prevent memory leaks in IE
      elem = null;
   },

   global: {},

   // Detach an event or set of events from an element
   remove: function( elem, types, handler, selector, mappedTypes ) {

      var t, tns, type, origType, namespaces, origCount,
         j, events, special, eventType, handleObj,
         elemData = jQuery.hasData( elem ) && jQuery._data( elem );

      if ( !elemData || !(events = elemData.events) ) {
         return;
      }

      // Once for each type.namespace in types; type may be omitted
      types = jQuery.trim( hoverHack( types || "" ) ).split(" ");
      for ( t = 0; t < types.length; t++ ) {
         tns = rtypenamespace.exec( types[t] ) || [];
         type = origType = tns[1];
         namespaces = tns[2];

         // Unbind all events (on this namespace, if provided) for the element
         if ( !type ) {
            for ( type in events ) {
               jQuery.event.remove( elem, type + types[ t ], handler, selector, true );
            }
            continue;
         }

         special = jQuery.event.special[ type ] || {};
         type = ( selector? special.delegateType : special.bindType ) || type;
         eventType = events[ type ] || [];
         origCount = eventType.length;
         namespaces = namespaces ? new RegExp("(^|\\.)" + namespaces.split(".").sort().join("\\.(?:.*\\.|)") + "(\\.|$)") : null;

         // Remove matching events
         for ( j = 0; j < eventType.length; j++ ) {
            handleObj = eventType[ j ];

            if ( ( mappedTypes || origType === handleObj.origType ) &&
                ( !handler || handler.guid === handleObj.guid ) &&
                ( !namespaces || namespaces.test( handleObj.namespace ) ) &&
                ( !selector || selector === handleObj.selector || selector === "**" && handleObj.selector ) ) {
               eventType.splice( j--, 1 );

               if ( handleObj.selector ) {
                  eventType.delegateCount--;
               }
               if ( special.remove ) {
                  special.remove.call( elem, handleObj );
               }
            }
         }

         // Remove generic event handler if we removed something and no more handlers exist
         // (avoids potential for endless recursion during removal of special event handlers)
         if ( eventType.length === 0 && origCount !== eventType.length ) {
            if ( !special.teardown || special.teardown.call( elem, namespaces, elemData.handle ) === false ) {
               jQuery.removeEvent( elem, type, elemData.handle );
            }

            delete events[ type ];
         }
      }

      // Remove the expando if it's no longer used
      if ( jQuery.isEmptyObject( events ) ) {
         delete elemData.handle;

         // removeData also checks for emptiness and clears the expando if empty
         // so use it instead of delete
         jQuery.removeData( elem, "events", true );
      }
   },

   // Events that are safe to short-circuit if no handlers are attached.
   // Native DOM events should not be added, they may have inline handlers.
   customEvent: {
      "getData": true,
      "setData": true,
      "changeData": true
   },

   trigger: function( event, data, elem, onlyHandlers ) {
      // Don't do events on text and comment nodes
      if ( elem && (elem.nodeType === 3 || elem.nodeType === 8) ) {
         return;
      }

      // Event object or event type
      var cache, exclusive, i, cur, old, ontype, special, handle, eventPath, bubbleType,
         type = event.type || event,
         namespaces = [];

      // focus/blur morphs to focusin/out; ensure we're not firing them right now
      if ( rfocusMorph.test( type + jQuery.event.triggered ) ) {
         return;
      }

      if ( type.indexOf( "!" ) >= 0 ) {
         // Exclusive events trigger only for the exact event (no namespaces)
         type = type.slice(0, -1);
         exclusive = true;
      }

      if ( type.indexOf( "." ) >= 0 ) {
         // Namespaced trigger; create a regexp to match event type in handle()
         namespaces = type.split(".");
         type = namespaces.shift();
         namespaces.sort();
      }

      if ( (!elem || jQuery.event.customEvent[ type ]) && !jQuery.event.global[ type ] ) {
         // No jQuery handlers for this event type, and it can't have inline handlers
         return;
      }

      // Caller can pass in an Event, Object, or just an event type string
      event = typeof event === "object" ?
         // jQuery.Event object
         event[ jQuery.expando ] ? event :
         // Object literal
         new jQuery.Event( type, event ) :
         // Just the event type (string)
         new jQuery.Event( type );

      event.type = type;
      event.isTrigger = true;
      event.exclusive = exclusive;
      event.namespace = namespaces.join( "." );
      event.namespace_re = event.namespace? new RegExp("(^|\\.)" + namespaces.join("\\.(?:.*\\.|)") + "(\\.|$)") : null;
      ontype = type.indexOf( ":" ) < 0 ? "on" + type : "";

      // Handle a global trigger
      if ( !elem ) {

         // TODO: Stop taunting the data cache; remove global events and always attach to document
         cache = jQuery.cache;
         for ( i in cache ) {
            if ( cache[ i ].events && cache[ i ].events[ type ] ) {
               jQuery.event.trigger( event, data, cache[ i ].handle.elem, true );
            }
         }
         return;
      }

      // Clean up the event in case it is being reused
      event.result = undefined;
      if ( !event.target ) {
         event.target = elem;
      }

      // Clone any incoming data and prepend the event, creating the handler arg list
      data = data != null ? jQuery.makeArray( data ) : [];
      data.unshift( event );

      // Allow special events to draw outside the lines
      special = jQuery.event.special[ type ] || {};
      if ( special.trigger && special.trigger.apply( elem, data ) === false ) {
         return;
      }

      // Determine event propagation path in advance, per W3C events spec (#9951)
      // Bubble up to document, then to window; watch for a global ownerDocument var (#9724)
      eventPath = [[ elem, special.bindType || type ]];
      if ( !onlyHandlers && !special.noBubble && !jQuery.isWindow( elem ) ) {

         bubbleType = special.delegateType || type;
         cur = rfocusMorph.test( bubbleType + type ) ? elem : elem.parentNode;
         for ( old = elem; cur; cur = cur.parentNode ) {
            eventPath.push([ cur, bubbleType ]);
            old = cur;
         }

         // Only add window if we got to document (e.g., not plain obj or detached DOM)
         if ( old === (elem.ownerDocument || document) ) {
            eventPath.push([ old.defaultView || old.parentWindow || window, bubbleType ]);
         }
      }

      // Fire handlers on the event path
      for ( i = 0; i < eventPath.length && !event.isPropagationStopped(); i++ ) {

         cur = eventPath[i][0];
         event.type = eventPath[i][1];

         handle = ( jQuery._data( cur, "events" ) || {} )[ event.type ] && jQuery._data( cur, "handle" );
         if ( handle ) {
            handle.apply( cur, data );
         }
         // Note that this is a bare JS function and not a jQuery handler
         handle = ontype && cur[ ontype ];
         if ( handle && jQuery.acceptData( cur ) && handle.apply && handle.apply( cur, data ) === false ) {
            event.preventDefault();
         }
      }
      event.type = type;

      // If nobody prevented the default action, do it now
      if ( !onlyHandlers && !event.isDefaultPrevented() ) {

         if ( (!special._default || special._default.apply( elem.ownerDocument, data ) === false) &&
            !(type === "click" && jQuery.nodeName( elem, "a" )) && jQuery.acceptData( elem ) ) {

            // Call a native DOM method on the target with the same name name as the event.
            // Can't use an .isFunction() check here because IE6/7 fails that test.
            // Don't do default actions on window, that's where global variables be (#6170)
            // IE<9 dies on focus/blur to hidden element (#1486)
            if ( ontype && elem[ type ] && ((type !== "focus" && type !== "blur") || event.target.offsetWidth !== 0) && !jQuery.isWindow( elem ) ) {

               // Don't re-trigger an onFOO event when we call its FOO() method
               old = elem[ ontype ];

               if ( old ) {
                  elem[ ontype ] = null;
               }

               // Prevent re-triggering of the same event, since we already bubbled it above
               jQuery.event.triggered = type;
               elem[ type ]();
               jQuery.event.triggered = undefined;

               if ( old ) {
                  elem[ ontype ] = old;
               }
            }
         }
      }

      return event.result;
   },

   dispatch: function( event ) {

      // Make a writable jQuery.Event from the native event object
      event = jQuery.event.fix( event || window.event );

      var i, j, cur, ret, selMatch, matched, matches, handleObj, sel, related,
         handlers = ( (jQuery._data( this, "events" ) || {} )[ event.type ] || []),
         delegateCount = handlers.delegateCount,
         args = core_slice.call( arguments ),
         run_all = !event.exclusive && !event.namespace,
         special = jQuery.event.special[ event.type ] || {},
         handlerQueue = [];

      // Use the fix-ed jQuery.Event rather than the (read-only) native event
      args[0] = event;
      event.delegateTarget = this;

      // Call the preDispatch hook for the mapped type, and let it bail if desired
      if ( special.preDispatch && special.preDispatch.call( this, event ) === false ) {
         return;
      }

      // Determine handlers that should run if there are delegated events
      // Avoid non-left-click bubbling in Firefox (#3861)
      if ( delegateCount && !(event.button && event.type === "click") ) {

         for ( cur = event.target; cur != this; cur = cur.parentNode || this ) {

            // Don't process clicks (ONLY) on disabled elements (#6911, #8165, #11382, #11764)
            if ( cur.disabled !== true || event.type !== "click" ) {
               selMatch = {};
               matches = [];
               for ( i = 0; i < delegateCount; i++ ) {
                  handleObj = handlers[ i ];
                  sel = handleObj.selector;

                  if ( selMatch[ sel ] === undefined ) {
                     selMatch[ sel ] = handleObj.needsContext ?
                        jQuery( sel, this ).index( cur ) >= 0 :
                        jQuery.find( sel, this, null, [ cur ] ).length;
                  }
                  if ( selMatch[ sel ] ) {
                     matches.push( handleObj );
                  }
               }
               if ( matches.length ) {
                  handlerQueue.push({ elem: cur, matches: matches });
               }
            }
         }
      }

      // Add the remaining (directly-bound) handlers
      if ( handlers.length > delegateCount ) {
         handlerQueue.push({ elem: this, matches: handlers.slice( delegateCount ) });
      }

      // Run delegates first; they may want to stop propagation beneath us
      for ( i = 0; i < handlerQueue.length && !event.isPropagationStopped(); i++ ) {
         matched = handlerQueue[ i ];
         event.currentTarget = matched.elem;

         for ( j = 0; j < matched.matches.length && !event.isImmediatePropagationStopped(); j++ ) {
            handleObj = matched.matches[ j ];

            // Triggered event must either 1) be non-exclusive and have no namespace, or
            // 2) have namespace(s) a subset or equal to those in the bound event (both can have no namespace).
            if ( run_all || (!event.namespace && !handleObj.namespace) || event.namespace_re && event.namespace_re.test( handleObj.namespace ) ) {

               event.data = handleObj.data;
               event.handleObj = handleObj;

               ret = ( (jQuery.event.special[ handleObj.origType ] || {}).handle || handleObj.handler )
                     .apply( matched.elem, args );

               if ( ret !== undefined ) {
                  event.result = ret;
                  if ( ret === false ) {
                     event.preventDefault();
                     event.stopPropagation();
                  }
               }
            }
         }
      }

      // Call the postDispatch hook for the mapped type
      if ( special.postDispatch ) {
         special.postDispatch.call( this, event );
      }

      return event.result;
   },

   // Includes some event props shared by KeyEvent and MouseEvent
   // *** attrChange attrName relatedNode srcElement  are not normalized, non-W3C, deprecated, will be removed in 1.8 ***
   props: "attrChange attrName relatedNode srcElement altKey bubbles cancelable ctrlKey currentTarget eventPhase metaKey relatedTarget shiftKey target timeStamp view which".split(" "),

   fixHooks: {},

   keyHooks: {
      props: "char charCode key keyCode".split(" "),
      filter: function( event, original ) {

         // Add which for key events
         if ( event.which == null ) {
            event.which = original.charCode != null ? original.charCode : original.keyCode;
         }

         return event;
      }
   },

   mouseHooks: {
      props: "button buttons clientX clientY fromElement offsetX offsetY pageX pageY screenX screenY toElement".split(" "),
      filter: function( event, original ) {
         var eventDoc, doc, body,
            button = original.button,
            fromElement = original.fromElement;

         // Calculate pageX/Y if missing and clientX/Y available
         if ( event.pageX == null && original.clientX != null ) {
            eventDoc = event.target.ownerDocument || document;
            doc = eventDoc.documentElement;
            body = eventDoc.body;

            event.pageX = original.clientX + ( doc && doc.scrollLeft || body && body.scrollLeft || 0 ) - ( doc && doc.clientLeft || body && body.clientLeft || 0 );
            event.pageY = original.clientY + ( doc && doc.scrollTop  || body && body.scrollTop  || 0 ) - ( doc && doc.clientTop  || body && body.clientTop  || 0 );
         }

         // Add relatedTarget, if necessary
         if ( !event.relatedTarget && fromElement ) {
            event.relatedTarget = fromElement === event.target ? original.toElement : fromElement;
         }

         // Add which for click: 1 === left; 2 === middle; 3 === right
         // Note: button is not normalized, so don't use it
         if ( !event.which && button !== undefined ) {
            event.which = ( button & 1 ? 1 : ( button & 2 ? 3 : ( button & 4 ? 2 : 0 ) ) );
         }

         return event;
      }
   },

   fix: function( event ) {
      if ( event[ jQuery.expando ] ) {
         return event;
      }

      // Create a writable copy of the event object and normalize some properties
      var i, prop,
         originalEvent = event,
         fixHook = jQuery.event.fixHooks[ event.type ] || {},
         copy = fixHook.props ? this.props.concat( fixHook.props ) : this.props;

      event = jQuery.Event( originalEvent );

      for ( i = copy.length; i; ) {
         prop = copy[ --i ];
         event[ prop ] = originalEvent[ prop ];
      }

      // Fix target property, if necessary (#1925, IE 6/7/8 & Safari2)
      if ( !event.target ) {
         event.target = originalEvent.srcElement || document;
      }

      // Target should not be a text node (#504, Safari)
      if ( event.target.nodeType === 3 ) {
         event.target = event.target.parentNode;
      }

      // For mouse/key events, metaKey==false if it's undefined (#3368, #11328; IE6/7/8)
      event.metaKey = !!event.metaKey;

      return fixHook.filter? fixHook.filter( event, originalEvent ) : event;
   },

   special: {
      load: {
         // Prevent triggered image.load events from bubbling to window.load
         noBubble: true
      },

      focus: {
         delegateType: "focusin"
      },
      blur: {
         delegateType: "focusout"
      },

      beforeunload: {
         setup: function( data, namespaces, eventHandle ) {
            // We only want to do this special case on windows
            if ( jQuery.isWindow( this ) ) {
               this.onbeforeunload = eventHandle;
            }
         },

         teardown: function( namespaces, eventHandle ) {
            if ( this.onbeforeunload === eventHandle ) {
               this.onbeforeunload = null;
            }
         }
      }
   },

   simulate: function( type, elem, event, bubble ) {
      // Piggyback on a donor event to simulate a different one.
      // Fake originalEvent to avoid donor's stopPropagation, but if the
      // simulated event prevents default then we do the same on the donor.
      var e = jQuery.extend(
         new jQuery.Event(),
         event,
         { type: type,
            isSimulated: true,
            originalEvent: {}
         }
      );
      if ( bubble ) {
         jQuery.event.trigger( e, null, elem );
      } else {
         jQuery.event.dispatch.call( elem, e );
      }
      if ( e.isDefaultPrevented() ) {
         event.preventDefault();
      }
   }
};

// Some plugins are using, but it's undocumented/deprecated and will be removed.
// The 1.7 special event interface should provide all the hooks needed now.
jQuery.event.handle = jQuery.event.dispatch;

jQuery.removeEvent = document.removeEventListener ?
   function( elem, type, handle ) {
      if ( elem.removeEventListener ) {
         elem.removeEventListener( type, handle, false );
      }
   } :
   function( elem, type, handle ) {
      var name = "on" + type;

      if ( elem.detachEvent ) {

         // #8545, #7054, preventing memory leaks for custom events in IE6-8 –
         // detachEvent needed property on element, by name of that event, to properly expose it to GC
         if ( typeof elem[ name ] === "undefined" ) {
            elem[ name ] = null;
         }

         elem.detachEvent( name, handle );
      }
   };

jQuery.Event = function( src, props ) {
   // Allow instantiation without the 'new' keyword
   if ( !(this instanceof jQuery.Event) ) {
      return new jQuery.Event( src, props );
   }

   // Event object
   if ( src && src.type ) {
      this.originalEvent = src;
      this.type = src.type;

      // Events bubbling up the document may have been marked as prevented
      // by a handler lower down the tree; reflect the correct value.
      this.isDefaultPrevented = ( src.defaultPrevented || src.returnValue === false ||
         src.getPreventDefault && src.getPreventDefault() ) ? returnTrue : returnFalse;

   // Event type
   } else {
      this.type = src;
   }

   // Put explicitly provided properties onto the event object
   if ( props ) {
      jQuery.extend( this, props );
   }

   // Create a timestamp if incoming event doesn't have one
   this.timeStamp = src && src.timeStamp || jQuery.now();

   // Mark it as fixed
   this[ jQuery.expando ] = true;
};

function returnFalse() {
   return false;
}
function returnTrue() {
   return true;
}

// jQuery.Event is based on DOM3 Events as specified by the ECMAScript Language Binding
// http://www.w3.org/TR/2003/WD-DOM-Level-3-Events-20030331/ecma-script-binding.html
jQuery.Event.prototype = {
   preventDefault: function() {
      this.isDefaultPrevented = returnTrue;

      var e = this.originalEvent;
      if ( !e ) {
         return;
      }

      // if preventDefault exists run it on the original event
      if ( e.preventDefault ) {
         e.preventDefault();

      // otherwise set the returnValue property of the original event to false (IE)
      } else {
         e.returnValue = false;
      }
   },
   stopPropagation: function() {
      this.isPropagationStopped = returnTrue;

      var e = this.originalEvent;
      if ( !e ) {
         return;
      }
      // if stopPropagation exists run it on the original event
      if ( e.stopPropagation ) {
         e.stopPropagation();
      }
      // otherwise set the cancelBubble property of the original event to true (IE)
      e.cancelBubble = true;
   },
   stopImmediatePropagation: function() {
      this.isImmediatePropagationStopped = returnTrue;
      this.stopPropagation();
   },
   isDefaultPrevented: returnFalse,
   isPropagationStopped: returnFalse,
   isImmediatePropagationStopped: returnFalse
};

// Create mouseenter/leave events using mouseover/out and event-time checks
jQuery.each({
   mouseenter: "mouseover",
   mouseleave: "mouseout"
}, function( orig, fix ) {
   jQuery.event.special[ orig ] = {
      delegateType: fix,
      bindType: fix,

      handle: function( event ) {
         var ret,
            target = this,
            related = event.relatedTarget,
            handleObj = event.handleObj,
            selector = handleObj.selector;

         // For mousenter/leave call the handler if related is outside the target.
         // NB: No relatedTarget if the mouse left/entered the browser window
         if ( !related || (related !== target && !jQuery.contains( target, related )) ) {
            event.type = handleObj.origType;
            ret = handleObj.handler.apply( this, arguments );
            event.type = fix;
         }
         return ret;
      }
   };
});

// IE submit delegation
if ( !jQuery.support.submitBubbles ) {

   jQuery.event.special.submit = {
      setup: function() {
         // Only need this for delegated form submit events
         if ( jQuery.nodeName( this, "form" ) ) {
            return false;
         }

         // Lazy-add a submit handler when a descendant form may potentially be submitted
         jQuery.event.add( this, "click._submit keypress._submit", function( e ) {
            // Node name check avoids a VML-related crash in IE (#9807)
            var elem = e.target,
               form = jQuery.nodeName( elem, "input" ) || jQuery.nodeName( elem, "button" ) ? elem.form : undefined;
            if ( form && !jQuery._data( form, "_submit_attached" ) ) {
               jQuery.event.add( form, "submit._submit", function( event ) {
                  event._submit_bubble = true;
               });
               jQuery._data( form, "_submit_attached", true );
            }
         });
         // return undefined since we don't need an event listener
      },

      postDispatch: function( event ) {
         // If form was submitted by the user, bubble the event up the tree
         if ( event._submit_bubble ) {
            delete event._submit_bubble;
            if ( this.parentNode && !event.isTrigger ) {
               jQuery.event.simulate( "submit", this.parentNode, event, true );
            }
         }
      },

      teardown: function() {
         // Only need this for delegated form submit events
         if ( jQuery.nodeName( this, "form" ) ) {
            return false;
         }

         // Remove delegated handlers; cleanData eventually reaps submit handlers attached above
         jQuery.event.remove( this, "._submit" );
      }
   };
}

// IE change delegation and checkbox/radio fix
if ( !jQuery.support.changeBubbles ) {

   jQuery.event.special.change = {

      setup: function() {

         if ( rformElems.test( this.nodeName ) ) {
            // IE doesn't fire change on a check/radio until blur; trigger it on click
            // after a propertychange. Eat the blur-change in special.change.handle.
            // This still fires onchange a second time for check/radio after blur.
            if ( this.type === "checkbox" || this.type === "radio" ) {
               jQuery.event.add( this, "propertychange._change", function( event ) {
                  if ( event.originalEvent.propertyName === "checked" ) {
                     this._just_changed = true;
                  }
               });
               jQuery.event.add( this, "click._change", function( event ) {
                  if ( this._just_changed && !event.isTrigger ) {
                     this._just_changed = false;
                  }
                  // Allow triggered, simulated change events (#11500)
                  jQuery.event.simulate( "change", this, event, true );
               });
            }
            return false;
         }
         // Delegated event; lazy-add a change handler on descendant inputs
         jQuery.event.add( this, "beforeactivate._change", function( e ) {
            var elem = e.target;

            if ( rformElems.test( elem.nodeName ) && !jQuery._data( elem, "_change_attached" ) ) {
               jQuery.event.add( elem, "change._change", function( event ) {
                  if ( this.parentNode && !event.isSimulated && !event.isTrigger ) {
                     jQuery.event.simulate( "change", this.parentNode, event, true );
                  }
               });
               jQuery._data( elem, "_change_attached", true );
            }
         });
      },

      handle: function( event ) {
         var elem = event.target;

         // Swallow native change events from checkbox/radio, we already triggered them above
         if ( this !== elem || event.isSimulated || event.isTrigger || (elem.type !== "radio" && elem.type !== "checkbox") ) {
            return event.handleObj.handler.apply( this, arguments );
         }
      },

      teardown: function() {
         jQuery.event.remove( this, "._change" );

         return !rformElems.test( this.nodeName );
      }
   };
}

// Create "bubbling" focus and blur events
if ( !jQuery.support.focusinBubbles ) {
   jQuery.each({ focus: "focusin", blur: "focusout" }, function( orig, fix ) {

      // Attach a single capturing handler while someone wants focusin/focusout
      var attaches = 0,
         handler = function( event ) {
            jQuery.event.simulate( fix, event.target, jQuery.event.fix( event ), true );
         };

      jQuery.event.special[ fix ] = {
         setup: function() {
            if ( attaches++ === 0 ) {
               document.addEventListener( orig, handler, true );
            }
         },
         teardown: function() {
            if ( --attaches === 0 ) {
               document.removeEventListener( orig, handler, true );
            }
         }
      };
   });
}

jQuery.fn.extend({

   on: function( types, selector, data, fn, /*INTERNAL*/ one ) {
      var origFn, type;

      // Types can be a map of types/handlers
      if ( typeof types === "object" ) {
         // ( types-Object, selector, data )
         if ( typeof selector !== "string" ) { // && selector != null
            // ( types-Object, data )
            data = data || selector;
            selector = undefined;
         }
         for ( type in types ) {
            this.on( type, selector, data, types[ type ], one );
         }
         return this;
      }

      if ( data == null && fn == null ) {
         // ( types, fn )
         fn = selector;
         data = selector = undefined;
      } else if ( fn == null ) {
         if ( typeof selector === "string" ) {
            // ( types, selector, fn )
            fn = data;
            data = undefined;
         } else {
            // ( types, data, fn )
            fn = data;
            data = selector;
            selector = undefined;
         }
      }
      if ( fn === false ) {
         fn = returnFalse;
      } else if ( !fn ) {
         return this;
      }

      if ( one === 1 ) {
         origFn = fn;
         fn = function( event ) {
            // Can use an empty set, since event contains the info
            jQuery().off( event );
            return origFn.apply( this, arguments );
         };
         // Use same guid so caller can remove using origFn
         fn.guid = origFn.guid || ( origFn.guid = jQuery.guid++ );
      }
      return this.each( function() {
         jQuery.event.add( this, types, fn, data, selector );
      });
   },
   one: function( types, selector, data, fn ) {
      return this.on( types, selector, data, fn, 1 );
   },
   off: function( types, selector, fn ) {
      var handleObj, type;
      if ( types && types.preventDefault && types.handleObj ) {
         // ( event )  dispatched jQuery.Event
         handleObj = types.handleObj;
         jQuery( types.delegateTarget ).off(
            handleObj.namespace ? handleObj.origType + "." + handleObj.namespace : handleObj.origType,
            handleObj.selector,
            handleObj.handler
         );
         return this;
      }
      if ( typeof types === "object" ) {
         // ( types-object [, selector] )
         for ( type in types ) {
            this.off( type, selector, types[ type ] );
         }
         return this;
      }
      if ( selector === false || typeof selector === "function" ) {
         // ( types [, fn] )
         fn = selector;
         selector = undefined;
      }
      if ( fn === false ) {
         fn = returnFalse;
      }
      return this.each(function() {
         jQuery.event.remove( this, types, fn, selector );
      });
   },

   bind: function( types, data, fn ) {
      return this.on( types, null, data, fn );
   },
   unbind: function( types, fn ) {
      return this.off( types, null, fn );
   },

   live: function( types, data, fn ) {
      jQuery( this.context ).on( types, this.selector, data, fn );
      return this;
   },
   die: function( types, fn ) {
      jQuery( this.context ).off( types, this.selector || "**", fn );
      return this;
   },

   delegate: function( selector, types, data, fn ) {
      return this.on( types, selector, data, fn );
   },
   undelegate: function( selector, types, fn ) {
      // ( namespace ) or ( selector, types [, fn] )
      return arguments.length === 1 ? this.off( selector, "**" ) : this.off( types, selector || "**", fn );
   },

   trigger: function( type, data ) {
      return this.each(function() {
         jQuery.event.trigger( type, data, this );
      });
   },
   triggerHandler: function( type, data ) {
      if ( this[0] ) {
         return jQuery.event.trigger( type, data, this[0], true );
      }
   },

   toggle: function( fn ) {
      // Save reference to arguments for access in closure
      var args = arguments,
         guid = fn.guid || jQuery.guid++,
         i = 0,
         toggler = function( event ) {
            // Figure out which function to execute
            var lastToggle = ( jQuery._data( this, "lastToggle" + fn.guid ) || 0 ) % i;
            jQuery._data( this, "lastToggle" + fn.guid, lastToggle + 1 );

            // Make sure that clicks stop
            event.preventDefault();

            // and execute the function
            return args[ lastToggle ].apply( this, arguments ) || false;
         };

      // link all the functions, so any of them can unbind this click handler
      toggler.guid = guid;
      while ( i < args.length ) {
         args[ i++ ].guid = guid;
      }

      return this.click( toggler );
   },

   hover: function( fnOver, fnOut ) {
      return this.mouseenter( fnOver ).mouseleave( fnOut || fnOver );
   }
});

jQuery.each( ("blur focus focusin focusout load resize scroll unload click dblclick " +
   "mousedown mouseup mousemove mouseover mouseout mouseenter mouseleave " +
   "change select submit keydown keypress keyup error contextmenu").split(" "), function( i, name ) {

   // Handle event binding
   jQuery.fn[ name ] = function( data, fn ) {
      if ( fn == null ) {
         fn = data;
         data = null;
      }

      return arguments.length > 0 ?
         this.on( name, null, data, fn ) :
         this.trigger( name );
   };

   if ( rkeyEvent.test( name ) ) {
      jQuery.event.fixHooks[ name ] = jQuery.event.keyHooks;
   }

   if ( rmouseEvent.test( name ) ) {
      jQuery.event.fixHooks[ name ] = jQuery.event.mouseHooks;
   }
});
/*!
 * Sizzle CSS Selector Engine
 * Copyright 2012 jQuery Foundation and other contributors
 * Released under the MIT license
 * http://sizzlejs.com/
 */
(function( window, undefined ) {

var cachedruns,
   assertGetIdNotName,
   Expr,
   getText,
   isXML,
   contains,
   compile,
   sortOrder,
   hasDuplicate,
   outermostContext,

   baseHasDuplicate = true,
   strundefined = "undefined",

   expando = ( "sizcache" + Math.random() ).replace( ".", "" ),

   Token = String,
   document = window.document,
   docElem = document.documentElement,
   dirruns = 0,
   done = 0,
   pop = [].pop,
   push = [].push,
   slice = [].slice,
   // Use a stripped-down indexOf if a native one is unavailable
   indexOf = [].indexOf || function( elem ) {
      var i = 0,
         len = this.length;
      for ( ; i < len; i++ ) {
         if ( this[i] === elem ) {
            return i;
         }
      }
      return -1;
   },

   // Augment a function for special use by Sizzle
   markFunction = function( fn, value ) {
      fn[ expando ] = value == null || value;
      return fn;
   },

   createCache = function() {
      var cache = {},
         keys = [];

      return markFunction(function( key, value ) {
         // Only keep the most recent entries
         if ( keys.push( key ) > Expr.cacheLength ) {
            delete cache[ keys.shift() ];
         }

         return (cache[ key ] = value);
      }, cache );
   },

   classCache = createCache(),
   tokenCache = createCache(),
   compilerCache = createCache(),

   // Regex

   // Whitespace characters http://www.w3.org/TR/css3-selectors/#whitespace
   whitespace = "[\\x20\\t\\r\\n\\f]",
   // http://www.w3.org/TR/css3-syntax/#characters
   characterEncoding = "(?:\\\\.|[-\\w]|[^\\x00-\\xa0])+",

   // Loosely modeled on CSS identifier characters
   // An unquoted value should be a CSS identifier (http://www.w3.org/TR/css3-selectors/#attribute-selectors)
   // Proper syntax: http://www.w3.org/TR/CSS21/syndata.html#value-def-identifier
   identifier = characterEncoding.replace( "w", "w#" ),

   // Acceptable operators http://www.w3.org/TR/selectors/#attribute-selectors
   operators = "([*^$|!~]?=)",
   attributes = "\\[" + whitespace + "*(" + characterEncoding + ")" + whitespace +
      "*(?:" + operators + whitespace + "*(?:(['\"])((?:\\\\.|[^\\\\])*?)\\3|(" + identifier + ")|)|)" + whitespace + "*\\]",

   // Prefer arguments not in parens/brackets,
   //   then attribute selectors and non-pseudos (denoted by :),
   //   then anything else
   // These preferences are here to reduce the number of selectors
   //   needing tokenize in the PSEUDO preFilter
   pseudos = ":(" + characterEncoding + ")(?:\\((?:(['\"])((?:\\\\.|[^\\\\])*?)\\2|([^()[\\]]*|(?:(?:" + attributes + ")|[^:]|\\\\.)*|.*))\\)|)",

   // For matchExpr.POS and matchExpr.needsContext
   pos = ":(even|odd|eq|gt|lt|nth|first|last)(?:\\(" + whitespace +
      "*((?:-\\d)?\\d*)" + whitespace + "*\\)|)(?=[^-]|$)",

   // Leading and non-escaped trailing whitespace, capturing some non-whitespace characters preceding the latter
   rtrim = new RegExp( "^" + whitespace + "+|((?:^|[^\\\\])(?:\\\\.)*)" + whitespace + "+$", "g" ),

   rcomma = new RegExp( "^" + whitespace + "*," + whitespace + "*" ),
   rcombinators = new RegExp( "^" + whitespace + "*([\\x20\\t\\r\\n\\f>+~])" + whitespace + "*" ),
   rpseudo = new RegExp( pseudos ),

   // Easily-parseable/retrievable ID or TAG or CLASS selectors
   rquickExpr = /^(?:#([\w\-]+)|(\w+)|\.([\w\-]+))$/,

   rnot = /^:not/,
   rsibling = /[\x20\t\r\n\f]*[+~]/,
   rendsWithNot = /:not\($/,

   rheader = /h\d/i,
   rinputs = /input|select|textarea|button/i,

   rbackslash = /\\(?!\\)/g,

   matchExpr = {
      "ID": new RegExp( "^#(" + characterEncoding + ")" ),
      "CLASS": new RegExp( "^\\.(" + characterEncoding + ")" ),
      "NAME": new RegExp( "^\\[name=['\"]?(" + characterEncoding + ")['\"]?\\]" ),
      "TAG": new RegExp( "^(" + characterEncoding.replace( "w", "w*" ) + ")" ),
      "ATTR": new RegExp( "^" + attributes ),
      "PSEUDO": new RegExp( "^" + pseudos ),
      "POS": new RegExp( pos, "i" ),
      "CHILD": new RegExp( "^:(only|nth|first|last)-child(?:\\(" + whitespace +
         "*(even|odd|(([+-]|)(\\d*)n|)" + whitespace + "*(?:([+-]|)" + whitespace +
         "*(\\d+)|))" + whitespace + "*\\)|)", "i" ),
      // For use in libraries implementing .is()
      "needsContext": new RegExp( "^" + whitespace + "*[>+~]|" + pos, "i" )
   },

   // Support

   // Used for testing something on an element
   assert = function( fn ) {
      var div = document.createElement("div");

      try {
         return fn( div );
      } catch (e) {
         return false;
      } finally {
         // release memory in IE
         div = null;
      }
   },

   // Check if getElementsByTagName("*") returns only elements
   assertTagNameNoComments = assert(function( div ) {
      div.appendChild( document.createComment("") );
      return !div.getElementsByTagName("*").length;
   }),

   // Check if getAttribute returns normalized href attributes
   assertHrefNotNormalized = assert(function( div ) {
      div.innerHTML = "<a href='#'></a>";
      return div.firstChild && typeof div.firstChild.getAttribute !== strundefined &&
         div.firstChild.getAttribute("href") === "#";
   }),

   // Check if attributes should be retrieved by attribute nodes
   assertAttributes = assert(function( div ) {
      div.innerHTML = "<select></select>";
      var type = typeof div.lastChild.getAttribute("multiple");
      // IE8 returns a string for some attributes even when not present
      return type !== "boolean" && type !== "string";
   }),

   // Check if getElementsByClassName can be trusted
   assertUsableClassName = assert(function( div ) {
      // Opera can't find a second classname (in 9.6)
      div.innerHTML = "<div class='hidden e'></div><div class='hidden'></div>";
      if ( !div.getElementsByClassName || !div.getElementsByClassName("e").length ) {
         return false;
      }

      // Safari 3.2 caches class attributes and doesn't catch changes
      div.lastChild.className = "e";
      return div.getElementsByClassName("e").length === 2;
   }),

   // Check if getElementById returns elements by name
   // Check if getElementsByName privileges form controls or returns elements by ID
   assertUsableName = assert(function( div ) {
      // Inject content
      div.id = expando + 0;
      div.innerHTML = "<a name='" + expando + "'></a><div name='" + expando + "'></div>";
      docElem.insertBefore( div, docElem.firstChild );

      // Test
      var pass = document.getElementsByName &&
         // buggy browsers will return fewer than the correct 2
         document.getElementsByName( expando ).length === 2 +
         // buggy browsers will return more than the correct 0
         document.getElementsByName( expando + 0 ).length;
      assertGetIdNotName = !document.getElementById( expando );

      // Cleanup
      docElem.removeChild( div );

      return pass;
   });

// If slice is not available, provide a backup
try {
   slice.call( docElem.childNodes, 0 )[0].nodeType;
} catch ( e ) {
   slice = function( i ) {
      var elem,
         results = [];
      for ( ; (elem = this[i]); i++ ) {
         results.push( elem );
      }
      return results;
   };
}

function Sizzle( selector, context, results, seed ) {
   results = results || [];
   context = context || document;
   var match, elem, xml, m,
      nodeType = context.nodeType;

   if ( !selector || typeof selector !== "string" ) {
      return results;
   }

   if ( nodeType !== 1 && nodeType !== 9 ) {
      return [];
   }

   xml = isXML( context );

   if ( !xml && !seed ) {
      if ( (match = rquickExpr.exec( selector )) ) {
         // Speed-up: Sizzle("#ID")
         if ( (m = match[1]) ) {
            if ( nodeType === 9 ) {
               elem = context.getElementById( m );
               // Check parentNode to catch when Blackberry 4.6 returns
               // nodes that are no longer in the document #6963
               if ( elem && elem.parentNode ) {
                  // Handle the case where IE, Opera, and Webkit return items
                  // by name instead of ID
                  if ( elem.id === m ) {
                     results.push( elem );
                     return results;
                  }
               } else {
                  return results;
               }
            } else {
               // Context is not a document
               if ( context.ownerDocument && (elem = context.ownerDocument.getElementById( m )) &&
                  contains( context, elem ) && elem.id === m ) {
                  results.push( elem );
                  return results;
               }
            }

         // Speed-up: Sizzle("TAG")
         } else if ( match[2] ) {
            push.apply( results, slice.call(context.getElementsByTagName( selector ), 0) );
            return results;

         // Speed-up: Sizzle(".CLASS")
         } else if ( (m = match[3]) && assertUsableClassName && context.getElementsByClassName ) {
            push.apply( results, slice.call(context.getElementsByClassName( m ), 0) );
            return results;
         }
      }
   }

   // All others
   return select( selector.replace( rtrim, "$1" ), context, results, seed, xml );
}

Sizzle.matches = function( expr, elements ) {
   return Sizzle( expr, null, null, elements );
};

Sizzle.matchesSelector = function( elem, expr ) {
   return Sizzle( expr, null, null, [ elem ] ).length > 0;
};

// Returns a function to use in pseudos for input types
function createInputPseudo( type ) {
   return function( elem ) {
      var name = elem.nodeName.toLowerCase();
      return name === "input" && elem.type === type;
   };
}

// Returns a function to use in pseudos for buttons
function createButtonPseudo( type ) {
   return function( elem ) {
      var name = elem.nodeName.toLowerCase();
      return (name === "input" || name === "button") && elem.type === type;
   };
}

// Returns a function to use in pseudos for positionals
function createPositionalPseudo( fn ) {
   return markFunction(function( argument ) {
      argument = +argument;
      return markFunction(function( seed, matches ) {
         var j,
            matchIndexes = fn( [], seed.length, argument ),
            i = matchIndexes.length;

         // Match elements found at the specified indexes
         while ( i-- ) {
            if ( seed[ (j = matchIndexes[i]) ] ) {
               seed[j] = !(matches[j] = seed[j]);
            }
         }
      });
   });
}

/**
 * Utility function for retrieving the text value of an array of DOM nodes
 * @param {Array|Element} elem
 */
getText = Sizzle.getText = function( elem ) {
   var node,
      ret = "",
      i = 0,
      nodeType = elem.nodeType;

   if ( nodeType ) {
      if ( nodeType === 1 || nodeType === 9 || nodeType === 11 ) {
         // Use textContent for elements
         // innerText usage removed for consistency of new lines (see #11153)
         if ( typeof elem.textContent === "string" ) {
            return elem.textContent;
         } else {
            // Traverse its children
            for ( elem = elem.firstChild; elem; elem = elem.nextSibling ) {
               ret += getText( elem );
            }
         }
      } else if ( nodeType === 3 || nodeType === 4 ) {
         return elem.nodeValue;
      }
      // Do not include comment or processing instruction nodes
   } else {

      // If no nodeType, this is expected to be an array
      for ( ; (node = elem[i]); i++ ) {
         // Do not traverse comment nodes
         ret += getText( node );
      }
   }
   return ret;
};

isXML = Sizzle.isXML = function( elem ) {
   // documentElement is verified for cases where it doesn't yet exist
   // (such as loading iframes in IE - #4833)
   var documentElement = elem && (elem.ownerDocument || elem).documentElement;
   return documentElement ? documentElement.nodeName !== "HTML" : false;
};

// Element contains another
contains = Sizzle.contains = docElem.contains ?
   function( a, b ) {
      var adown = a.nodeType === 9 ? a.documentElement : a,
         bup = b && b.parentNode;
      return a === bup || !!( bup && bup.nodeType === 1 && adown.contains && adown.contains(bup) );
   } :
   docElem.compareDocumentPosition ?
   function( a, b ) {
      return b && !!( a.compareDocumentPosition( b ) & 16 );
   } :
   function( a, b ) {
      while ( (b = b.parentNode) ) {
         if ( b === a ) {
            return true;
         }
      }
      return false;
   };

Sizzle.attr = function( elem, name ) {
   var val,
      xml = isXML( elem );

   if ( !xml ) {
      name = name.toLowerCase();
   }
   if ( (val = Expr.attrHandle[ name ]) ) {
      return val( elem );
   }
   if ( xml || assertAttributes ) {
      return elem.getAttribute( name );
   }
   val = elem.getAttributeNode( name );
   return val ?
      typeof elem[ name ] === "boolean" ?
         elem[ name ] ? name : null :
         val.specified ? val.value : null :
      null;
};

Expr = Sizzle.selectors = {

   // Can be adjusted by the user
   cacheLength: 50,

   createPseudo: markFunction,

   match: matchExpr,

   // IE6/7 return a modified href
   attrHandle: assertHrefNotNormalized ?
      {} :
      {
         "href": function( elem ) {
            return elem.getAttribute( "href", 2 );
         },
         "type": function( elem ) {
            return elem.getAttribute("type");
         }
      },

   find: {
      "ID": assertGetIdNotName ?
         function( id, context, xml ) {
            if ( typeof context.getElementById !== strundefined && !xml ) {
               var m = context.getElementById( id );
               // Check parentNode to catch when Blackberry 4.6 returns
               // nodes that are no longer in the document #6963
               return m && m.parentNode ? [m] : [];
            }
         } :
         function( id, context, xml ) {
            if ( typeof context.getElementById !== strundefined && !xml ) {
               var m = context.getElementById( id );

               return m ?
                  m.id === id || typeof m.getAttributeNode !== strundefined && m.getAttributeNode("id").value === id ?
                     [m] :
                     undefined :
                  [];
            }
         },

      "TAG": assertTagNameNoComments ?
         function( tag, context ) {
            if ( typeof context.getElementsByTagName !== strundefined ) {
               return context.getElementsByTagName( tag );
            }
         } :
         function( tag, context ) {
            var results = context.getElementsByTagName( tag );

            // Filter out possible comments
            if ( tag === "*" ) {
               var elem,
                  tmp = [],
                  i = 0;

               for ( ; (elem = results[i]); i++ ) {
                  if ( elem.nodeType === 1 ) {
                     tmp.push( elem );
                  }
               }

               return tmp;
            }
            return results;
         },

      "NAME": assertUsableName && function( tag, context ) {
         if ( typeof context.getElementsByName !== strundefined ) {
            return context.getElementsByName( name );
         }
      },

      "CLASS": assertUsableClassName && function( className, context, xml ) {
         if ( typeof context.getElementsByClassName !== strundefined && !xml ) {
            return context.getElementsByClassName( className );
         }
      }
   },

   relative: {
      ">": { dir: "parentNode", first: true },
      " ": { dir: "parentNode" },
      "+": { dir: "previousSibling", first: true },
      "~": { dir: "previousSibling" }
   },

   preFilter: {
      "ATTR": function( match ) {
         match[1] = match[1].replace( rbackslash, "" );

         // Move the given value to match[3] whether quoted or unquoted
         match[3] = ( match[4] || match[5] || "" ).replace( rbackslash, "" );

         if ( match[2] === "~=" ) {
            match[3] = " " + match[3] + " ";
         }

         return match.slice( 0, 4 );
      },

      "CHILD": function( match ) {
         /* matches from matchExpr["CHILD"]
            1 type (only|nth|...)
            2 argument (even|odd|\d*|\d*n([+-]\d+)?|...)
            3 xn-component of xn+y argument ([+-]?\d*n|)
            4 sign of xn-component
            5 x of xn-component
            6 sign of y-component
            7 y of y-component
         */
         match[1] = match[1].toLowerCase();

         if ( match[1] === "nth" ) {
            // nth-child requires argument
            if ( !match[2] ) {
               Sizzle.error( match[0] );
            }

            // numeric x and y parameters for Expr.filter.CHILD
            // remember that false/true cast respectively to 0/1
            match[3] = +( match[3] ? match[4] + (match[5] || 1) : 2 * ( match[2] === "even" || match[2] === "odd" ) );
            match[4] = +( ( match[6] + match[7] ) || match[2] === "odd" );

         // other types prohibit arguments
         } else if ( match[2] ) {
            Sizzle.error( match[0] );
         }

         return match;
      },

      "PSEUDO": function( match ) {
         var unquoted, excess;
         if ( matchExpr["CHILD"].test( match[0] ) ) {
            return null;
         }

         if ( match[3] ) {
            match[2] = match[3];
         } else if ( (unquoted = match[4]) ) {
            // Only check arguments that contain a pseudo
            if ( rpseudo.test(unquoted) &&
               // Get excess from tokenize (recursively)
               (excess = tokenize( unquoted, true )) &&
               // advance to the next closing parenthesis
               (excess = unquoted.indexOf( ")", unquoted.length - excess ) - unquoted.length) ) {

               // excess is a negative index
               unquoted = unquoted.slice( 0, excess );
               match[0] = match[0].slice( 0, excess );
            }
            match[2] = unquoted;
         }

         // Return only captures needed by the pseudo filter method (type and argument)
         return match.slice( 0, 3 );
      }
   },

   filter: {
      "ID": assertGetIdNotName ?
         function( id ) {
            id = id.replace( rbackslash, "" );
            return function( elem ) {
               return elem.getAttribute("id") === id;
            };
         } :
         function( id ) {
            id = id.replace( rbackslash, "" );
            return function( elem ) {
               var node = typeof elem.getAttributeNode !== strundefined && elem.getAttributeNode("id");
               return node && node.value === id;
            };
         },

      "TAG": function( nodeName ) {
         if ( nodeName === "*" ) {
            return function() { return true; };
         }
         nodeName = nodeName.replace( rbackslash, "" ).toLowerCase();

         return function( elem ) {
            return elem.nodeName && elem.nodeName.toLowerCase() === nodeName;
         };
      },

      "CLASS": function( className ) {
         var pattern = classCache[ expando ][ className ];
         if ( !pattern ) {
            pattern = classCache( className, new RegExp("(^|" + whitespace + ")" + className + "(" + whitespace + "|$)") );
         }
         return function( elem ) {
            return pattern.test( elem.className || (typeof elem.getAttribute !== strundefined && elem.getAttribute("class")) || "" );
         };
      },

      "ATTR": function( name, operator, check ) {
         return function( elem, context ) {
            var result = Sizzle.attr( elem, name );

            if ( result == null ) {
               return operator === "!=";
            }
            if ( !operator ) {
               return true;
            }

            result += "";

            return operator === "=" ? result === check :
               operator === "!=" ? result !== check :
               operator === "^=" ? check && result.indexOf( check ) === 0 :
               operator === "*=" ? check && result.indexOf( check ) > -1 :
               operator === "$=" ? check && result.substr( result.length - check.length ) === check :
               operator === "~=" ? ( " " + result + " " ).indexOf( check ) > -1 :
               operator === "|=" ? result === check || result.substr( 0, check.length + 1 ) === check + "-" :
               false;
         };
      },

      "CHILD": function( type, argument, first, last ) {

         if ( type === "nth" ) {
            return function( elem ) {
               var node, diff,
                  parent = elem.parentNode;

               if ( first === 1 && last === 0 ) {
                  return true;
               }

               if ( parent ) {
                  diff = 0;
                  for ( node = parent.firstChild; node; node = node.nextSibling ) {
                     if ( node.nodeType === 1 ) {
                        diff++;
                        if ( elem === node ) {
                           break;
                        }
                     }
                  }
               }

               // Incorporate the offset (or cast to NaN), then check against cycle size
               diff -= last;
               return diff === first || ( diff % first === 0 && diff / first >= 0 );
            };
         }

         return function( elem ) {
            var node = elem;

            switch ( type ) {
               case "only":
               case "first":
                  while ( (node = node.previousSibling) ) {
                     if ( node.nodeType === 1 ) {
                        return false;
                     }
                  }

                  if ( type === "first" ) {
                     return true;
                  }

                  node = elem;

                  /* falls through */
               case "last":
                  while ( (node = node.nextSibling) ) {
                     if ( node.nodeType === 1 ) {
                        return false;
                     }
                  }

                  return true;
            }
         };
      },

      "PSEUDO": function( pseudo, argument ) {
         // pseudo-class names are case-insensitive
         // http://www.w3.org/TR/selectors/#pseudo-classes
         // Prioritize by case sensitivity in case custom pseudos are added with uppercase letters
         // Remember that setFilters inherits from pseudos
         var args,
            fn = Expr.pseudos[ pseudo ] || Expr.setFilters[ pseudo.toLowerCase() ] ||
               Sizzle.error( "unsupported pseudo: " + pseudo );

         // The user may use createPseudo to indicate that
         // arguments are needed to create the filter function
         // just as Sizzle does
         if ( fn[ expando ] ) {
            return fn( argument );
         }

         // But maintain support for old signatures
         if ( fn.length > 1 ) {
            args = [ pseudo, pseudo, "", argument ];
            return Expr.setFilters.hasOwnProperty( pseudo.toLowerCase() ) ?
               markFunction(function( seed, matches ) {
                  var idx,
                     matched = fn( seed, argument ),
                     i = matched.length;
                  while ( i-- ) {
                     idx = indexOf.call( seed, matched[i] );
                     seed[ idx ] = !( matches[ idx ] = matched[i] );
                  }
               }) :
               function( elem ) {
                  return fn( elem, 0, args );
               };
         }

         return fn;
      }
   },

   pseudos: {
      "not": markFunction(function( selector ) {
         // Trim the selector passed to compile
         // to avoid treating leading and trailing
         // spaces as combinators
         var input = [],
            results = [],
            matcher = compile( selector.replace( rtrim, "$1" ) );

         return matcher[ expando ] ?
            markFunction(function( seed, matches, context, xml ) {
               var elem,
                  unmatched = matcher( seed, null, xml, [] ),
                  i = seed.length;

               // Match elements unmatched by `matcher`
               while ( i-- ) {
                  if ( (elem = unmatched[i]) ) {
                     seed[i] = !(matches[i] = elem);
                  }
               }
            }) :
            function( elem, context, xml ) {
               input[0] = elem;
               matcher( input, null, xml, results );
               return !results.pop();
            };
      }),

      "has": markFunction(function( selector ) {
         return function( elem ) {
            return Sizzle( selector, elem ).length > 0;
         };
      }),

      "contains": markFunction(function( text ) {
         return function( elem ) {
            return ( elem.textContent || elem.innerText || getText( elem ) ).indexOf( text ) > -1;
         };
      }),

      "enabled": function( elem ) {
         return elem.disabled === false;
      },

      "disabled": function( elem ) {
         return elem.disabled === true;
      },

      "checked": function( elem ) {
         // In CSS3, :checked should return both checked and selected elements
         // http://www.w3.org/TR/2011/REC-css3-selectors-20110929/#checked
         var nodeName = elem.nodeName.toLowerCase();
         return (nodeName === "input" && !!elem.checked) || (nodeName === "option" && !!elem.selected);
      },

      "selected": function( elem ) {
         // Accessing this property makes selected-by-default
         // options in Safari work properly
         if ( elem.parentNode ) {
            elem.parentNode.selectedIndex;
         }

         return elem.selected === true;
      },

      "parent": function( elem ) {
         return !Expr.pseudos["empty"]( elem );
      },

      "empty": function( elem ) {
         // http://www.w3.org/TR/selectors/#empty-pseudo
         // :empty is only affected by element nodes and content nodes(including text(3), cdata(4)),
         //   not comment, processing instructions, or others
         // Thanks to Diego Perini for the nodeName shortcut
         //   Greater than "@" means alpha characters (specifically not starting with "#" or "?")
         var nodeType;
         elem = elem.firstChild;
         while ( elem ) {
            if ( elem.nodeName > "@" || (nodeType = elem.nodeType) === 3 || nodeType === 4 ) {
               return false;
            }
            elem = elem.nextSibling;
         }
         return true;
      },

      "header": function( elem ) {
         return rheader.test( elem.nodeName );
      },

      "text": function( elem ) {
         var type, attr;
         // IE6 and 7 will map elem.type to 'text' for new HTML5 types (search, etc)
         // use getAttribute instead to test this case
         return elem.nodeName.toLowerCase() === "input" &&
            (type = elem.type) === "text" &&
            ( (attr = elem.getAttribute("type")) == null || attr.toLowerCase() === type );
      },

      // Input types
      "radio": createInputPseudo("radio"),
      "checkbox": createInputPseudo("checkbox"),
      "file": createInputPseudo("file"),
      "password": createInputPseudo("password"),
      "image": createInputPseudo("image"),

      "submit": createButtonPseudo("submit"),
      "reset": createButtonPseudo("reset"),

      "button": function( elem ) {
         var name = elem.nodeName.toLowerCase();
         return name === "input" && elem.type === "button" || name === "button";
      },

      "input": function( elem ) {
         return rinputs.test( elem.nodeName );
      },

      "focus": function( elem ) {
         var doc = elem.ownerDocument;
         return elem === doc.activeElement && (!doc.hasFocus || doc.hasFocus()) && !!(elem.type || elem.href);
      },

      "active": function( elem ) {
         return elem === elem.ownerDocument.activeElement;
      },

      // Positional types
      "first": createPositionalPseudo(function( matchIndexes, length, argument ) {
         return [ 0 ];
      }),

      "last": createPositionalPseudo(function( matchIndexes, length, argument ) {
         return [ length - 1 ];
      }),

      "eq": createPositionalPseudo(function( matchIndexes, length, argument ) {
         return [ argument < 0 ? argument + length : argument ];
      }),

      "even": createPositionalPseudo(function( matchIndexes, length, argument ) {
         for ( var i = 0; i < length; i += 2 ) {
            matchIndexes.push( i );
         }
         return matchIndexes;
      }),

      "odd": createPositionalPseudo(function( matchIndexes, length, argument ) {
         for ( var i = 1; i < length; i += 2 ) {
            matchIndexes.push( i );
         }
         return matchIndexes;
      }),

      "lt": createPositionalPseudo(function( matchIndexes, length, argument ) {
         for ( var i = argument < 0 ? argument + length : argument; --i >= 0; ) {
            matchIndexes.push( i );
         }
         return matchIndexes;
      }),

      "gt": createPositionalPseudo(function( matchIndexes, length, argument ) {
         for ( var i = argument < 0 ? argument + length : argument; ++i < length; ) {
            matchIndexes.push( i );
         }
         return matchIndexes;
      })
   }
};

function siblingCheck( a, b, ret ) {
   if ( a === b ) {
      return ret;
   }

   var cur = a.nextSibling;

   while ( cur ) {
      if ( cur === b ) {
         return -1;
      }

      cur = cur.nextSibling;
   }

   return 1;
}

sortOrder = docElem.compareDocumentPosition ?
   function( a, b ) {
      if ( a === b ) {
         hasDuplicate = true;
         return 0;
      }

      return ( !a.compareDocumentPosition || !b.compareDocumentPosition ?
         a.compareDocumentPosition :
         a.compareDocumentPosition(b) & 4
      ) ? -1 : 1;
   } :
   function( a, b ) {
      // The nodes are identical, we can exit early
      if ( a === b ) {
         hasDuplicate = true;
         return 0;

      // Fallback to using sourceIndex (in IE) if it's available on both nodes
      } else if ( a.sourceIndex && b.sourceIndex ) {
         return a.sourceIndex - b.sourceIndex;
      }

      var al, bl,
         ap = [],
         bp = [],
         aup = a.parentNode,
         bup = b.parentNode,
         cur = aup;

      // If the nodes are siblings (or identical) we can do a quick check
      if ( aup === bup ) {
         return siblingCheck( a, b );

      // If no parents were found then the nodes are disconnected
      } else if ( !aup ) {
         return -1;

      } else if ( !bup ) {
         return 1;
      }

      // Otherwise they're somewhere else in the tree so we need
      // to build up a full list of the parentNodes for comparison
      while ( cur ) {
         ap.unshift( cur );
         cur = cur.parentNode;
      }

      cur = bup;

      while ( cur ) {
         bp.unshift( cur );
         cur = cur.parentNode;
      }

      al = ap.length;
      bl = bp.length;

      // Start walking down the tree looking for a discrepancy
      for ( var i = 0; i < al && i < bl; i++ ) {
         if ( ap[i] !== bp[i] ) {
            return siblingCheck( ap[i], bp[i] );
         }
      }

      // We ended someplace up the tree so do a sibling check
      return i === al ?
         siblingCheck( a, bp[i], -1 ) :
         siblingCheck( ap[i], b, 1 );
   };

// Always assume the presence of duplicates if sort doesn't
// pass them to our comparison function (as in Google Chrome).
[0, 0].sort( sortOrder );
baseHasDuplicate = !hasDuplicate;

// Document sorting and removing duplicates
Sizzle.uniqueSort = function( results ) {
   var elem,
      i = 1;

   hasDuplicate = baseHasDuplicate;
   results.sort( sortOrder );

   if ( hasDuplicate ) {
      for ( ; (elem = results[i]); i++ ) {
         if ( elem === results[ i - 1 ] ) {
            results.splice( i--, 1 );
         }
      }
   }

   return results;
};

Sizzle.error = function( msg ) {
   throw new Error( "Syntax error, unrecognized expression: " + msg );
};

function tokenize( selector, parseOnly ) {
   var matched, match, tokens, type, soFar, groups, preFilters,
      cached = tokenCache[ expando ][ selector ];

   if ( cached ) {
      return parseOnly ? 0 : cached.slice( 0 );
   }

   soFar = selector;
   groups = [];
   preFilters = Expr.preFilter;

   while ( soFar ) {

      // Comma and first run
      if ( !matched || (match = rcomma.exec( soFar )) ) {
         if ( match ) {
            soFar = soFar.slice( match[0].length );
         }
         groups.push( tokens = [] );
      }

      matched = false;

      // Combinators
      if ( (match = rcombinators.exec( soFar )) ) {
         tokens.push( matched = new Token( match.shift() ) );
         soFar = soFar.slice( matched.length );

         // Cast descendant combinators to space
         matched.type = match[0].replace( rtrim, " " );
      }

      // Filters
      for ( type in Expr.filter ) {
         if ( (match = matchExpr[ type ].exec( soFar )) && (!preFilters[ type ] ||
            // The last two arguments here are (context, xml) for backCompat
            (match = preFilters[ type ]( match, document, true ))) ) {

            tokens.push( matched = new Token( match.shift() ) );
            soFar = soFar.slice( matched.length );
            matched.type = type;
            matched.matches = match;
         }
      }

      if ( !matched ) {
         break;
      }
   }

   // Return the length of the invalid excess
   // if we're just parsing
   // Otherwise, throw an error or return tokens
   return parseOnly ?
      soFar.length :
      soFar ?
         Sizzle.error( selector ) :
         // Cache the tokens
         tokenCache( selector, groups ).slice( 0 );
}

function addCombinator( matcher, combinator, base ) {
   var dir = combinator.dir,
      checkNonElements = base && combinator.dir === "parentNode",
      doneName = done++;

   return combinator.first ?
      // Check against closest ancestor/preceding element
      function( elem, context, xml ) {
         while ( (elem = elem[ dir ]) ) {
            if ( checkNonElements || elem.nodeType === 1  ) {
               return matcher( elem, context, xml );
            }
         }
      } :

      // Check against all ancestor/preceding elements
      function( elem, context, xml ) {
         // We can't set arbitrary data on XML nodes, so they don't benefit from dir caching
         if ( !xml ) {
            var cache,
               dirkey = dirruns + " " + doneName + " ",
               cachedkey = dirkey + cachedruns;
            while ( (elem = elem[ dir ]) ) {
               if ( checkNonElements || elem.nodeType === 1 ) {
                  if ( (cache = elem[ expando ]) === cachedkey ) {
                     return elem.sizset;
                  } else if ( typeof cache === "string" && cache.indexOf(dirkey) === 0 ) {
                     if ( elem.sizset ) {
                        return elem;
                     }
                  } else {
                     elem[ expando ] = cachedkey;
                     if ( matcher( elem, context, xml ) ) {
                        elem.sizset = true;
                        return elem;
                     }
                     elem.sizset = false;
                  }
               }
            }
         } else {
            while ( (elem = elem[ dir ]) ) {
               if ( checkNonElements || elem.nodeType === 1 ) {
                  if ( matcher( elem, context, xml ) ) {
                     return elem;
                  }
               }
            }
         }
      };
}

function elementMatcher( matchers ) {
   return matchers.length > 1 ?
      function( elem, context, xml ) {
         var i = matchers.length;
         while ( i-- ) {
            if ( !matchers[i]( elem, context, xml ) ) {
               return false;
            }
         }
         return true;
      } :
      matchers[0];
}

function condense( unmatched, map, filter, context, xml ) {
   var elem,
      newUnmatched = [],
      i = 0,
      len = unmatched.length,
      mapped = map != null;

   for ( ; i < len; i++ ) {
      if ( (elem = unmatched[i]) ) {
         if ( !filter || filter( elem, context, xml ) ) {
            newUnmatched.push( elem );
            if ( mapped ) {
               map.push( i );
            }
         }
      }
   }

   return newUnmatched;
}

function setMatcher( preFilter, selector, matcher, postFilter, postFinder, postSelector ) {
   if ( postFilter && !postFilter[ expando ] ) {
      postFilter = setMatcher( postFilter );
   }
   if ( postFinder && !postFinder[ expando ] ) {
      postFinder = setMatcher( postFinder, postSelector );
   }
   return markFunction(function( seed, results, context, xml ) {
      // Positional selectors apply to seed elements, so it is invalid to follow them with relative ones
      if ( seed && postFinder ) {
         return;
      }

      var i, elem, postFilterIn,
         preMap = [],
         postMap = [],
         preexisting = results.length,

         // Get initial elements from seed or context
         elems = seed || multipleContexts( selector || "*", context.nodeType ? [ context ] : context, [], seed ),

         // Prefilter to get matcher input, preserving a map for seed-results synchronization
         matcherIn = preFilter && ( seed || !selector ) ?
            condense( elems, preMap, preFilter, context, xml ) :
            elems,

         matcherOut = matcher ?
            // If we have a postFinder, or filtered seed, or non-seed postFilter or preexisting results,
            postFinder || ( seed ? preFilter : preexisting || postFilter ) ?

               // ...intermediate processing is necessary
               [] :

               // ...otherwise use results directly
               results :
            matcherIn;

      // Find primary matches
      if ( matcher ) {
         matcher( matcherIn, matcherOut, context, xml );
      }

      // Apply postFilter
      if ( postFilter ) {
         postFilterIn = condense( matcherOut, postMap );
         postFilter( postFilterIn, [], context, xml );

         // Un-match failing elements by moving them back to matcherIn
         i = postFilterIn.length;
         while ( i-- ) {
            if ( (elem = postFilterIn[i]) ) {
               matcherOut[ postMap[i] ] = !(matcherIn[ postMap[i] ] = elem);
            }
         }
      }

      // Keep seed and results synchronized
      if ( seed ) {
         // Ignore postFinder because it can't coexist with seed
         i = preFilter && matcherOut.length;
         while ( i-- ) {
            if ( (elem = matcherOut[i]) ) {
               seed[ preMap[i] ] = !(results[ preMap[i] ] = elem);
            }
         }
      } else {
         matcherOut = condense(
            matcherOut === results ?
               matcherOut.splice( preexisting, matcherOut.length ) :
               matcherOut
         );
         if ( postFinder ) {
            postFinder( null, results, matcherOut, xml );
         } else {
            push.apply( results, matcherOut );
         }
      }
   });
}

function matcherFromTokens( tokens ) {
   var checkContext, matcher, j,
      len = tokens.length,
      leadingRelative = Expr.relative[ tokens[0].type ],
      implicitRelative = leadingRelative || Expr.relative[" "],
      i = leadingRelative ? 1 : 0,

      // The foundational matcher ensures that elements are reachable from top-level context(s)
      matchContext = addCombinator( function( elem ) {
         return elem === checkContext;
      }, implicitRelative, true ),
      matchAnyContext = addCombinator( function( elem ) {
         return indexOf.call( checkContext, elem ) > -1;
      }, implicitRelative, true ),
      matchers = [ function( elem, context, xml ) {
         return ( !leadingRelative && ( xml || context !== outermostContext ) ) || (
            (checkContext = context).nodeType ?
               matchContext( elem, context, xml ) :
               matchAnyContext( elem, context, xml ) );
      } ];

   for ( ; i < len; i++ ) {
      if ( (matcher = Expr.relative[ tokens[i].type ]) ) {
         matchers = [ addCombinator( elementMatcher( matchers ), matcher ) ];
      } else {
         // The concatenated values are (context, xml) for backCompat
         matcher = Expr.filter[ tokens[i].type ].apply( null, tokens[i].matches );

         // Return special upon seeing a positional matcher
         if ( matcher[ expando ] ) {
            // Find the next relative operator (if any) for proper handling
            j = ++i;
            for ( ; j < len; j++ ) {
               if ( Expr.relative[ tokens[j].type ] ) {
                  break;
               }
            }
            return setMatcher(
               i > 1 && elementMatcher( matchers ),
               i > 1 && tokens.slice( 0, i - 1 ).join("").replace( rtrim, "$1" ),
               matcher,
               i < j && matcherFromTokens( tokens.slice( i, j ) ),
               j < len && matcherFromTokens( (tokens = tokens.slice( j )) ),
               j < len && tokens.join("")
            );
         }
         matchers.push( matcher );
      }
   }

   return elementMatcher( matchers );
}

function matcherFromGroupMatchers( elementMatchers, setMatchers ) {
   var bySet = setMatchers.length > 0,
      byElement = elementMatchers.length > 0,
      superMatcher = function( seed, context, xml, results, expandContext ) {
         var elem, j, matcher,
            setMatched = [],
            matchedCount = 0,
            i = "0",
            unmatched = seed && [],
            outermost = expandContext != null,
            contextBackup = outermostContext,
            // We must always have either seed elements or context
            elems = seed || byElement && Expr.find["TAG"]( "*", expandContext && context.parentNode || context ),
            // Nested matchers should use non-integer dirruns
            dirrunsUnique = (dirruns += contextBackup == null ? 1 : Math.E);

         if ( outermost ) {
            outermostContext = context !== document && context;
            cachedruns = superMatcher.el;
         }

         // Add elements passing elementMatchers directly to results
         for ( ; (elem = elems[i]) != null; i++ ) {
            if ( byElement && elem ) {
               for ( j = 0; (matcher = elementMatchers[j]); j++ ) {
                  if ( matcher( elem, context, xml ) ) {
                     results.push( elem );
                     break;
                  }
               }
               if ( outermost ) {
                  dirruns = dirrunsUnique;
                  cachedruns = ++superMatcher.el;
               }
            }

            // Track unmatched elements for set filters
            if ( bySet ) {
               // They will have gone through all possible matchers
               if ( (elem = !matcher && elem) ) {
                  matchedCount--;
               }

               // Lengthen the array for every element, matched or not
               if ( seed ) {
                  unmatched.push( elem );
               }
            }
         }

         // Apply set filters to unmatched elements
         matchedCount += i;
         if ( bySet && i !== matchedCount ) {
            for ( j = 0; (matcher = setMatchers[j]); j++ ) {
               matcher( unmatched, setMatched, context, xml );
            }

            if ( seed ) {
               // Reintegrate element matches to eliminate the need for sorting
               if ( matchedCount > 0 ) {
                  while ( i-- ) {
                     if ( !(unmatched[i] || setMatched[i]) ) {
                        setMatched[i] = pop.call( results );
                     }
                  }
               }

               // Discard index placeholder values to get only actual matches
               setMatched = condense( setMatched );
            }

            // Add matches to results
            push.apply( results, setMatched );

            // Seedless set matches succeeding multiple successful matchers stipulate sorting
            if ( outermost && !seed && setMatched.length > 0 &&
               ( matchedCount + setMatchers.length ) > 1 ) {

               Sizzle.uniqueSort( results );
            }
         }

         // Override manipulation of globals by nested matchers
         if ( outermost ) {
            dirruns = dirrunsUnique;
            outermostContext = contextBackup;
         }

         return unmatched;
      };

   superMatcher.el = 0;
   return bySet ?
      markFunction( superMatcher ) :
      superMatcher;
}

compile = Sizzle.compile = function( selector, group /* Internal Use Only */ ) {
   var i,
      setMatchers = [],
      elementMatchers = [],
      cached = compilerCache[ expando ][ selector ];

   if ( !cached ) {
      // Generate a function of recursive functions that can be used to check each element
      if ( !group ) {
         group = tokenize( selector );
      }
      i = group.length;
      while ( i-- ) {
         cached = matcherFromTokens( group[i] );
         if ( cached[ expando ] ) {
            setMatchers.push( cached );
         } else {
            elementMatchers.push( cached );
         }
      }

      // Cache the compiled function
      cached = compilerCache( selector, matcherFromGroupMatchers( elementMatchers, setMatchers ) );
   }
   return cached;
};

function multipleContexts( selector, contexts, results, seed ) {
   var i = 0,
      len = contexts.length;
   for ( ; i < len; i++ ) {
      Sizzle( selector, contexts[i], results, seed );
   }
   return results;
}

function select( selector, context, results, seed, xml ) {
   var i, tokens, token, type, find,
      match = tokenize( selector ),
      j = match.length;

   if ( !seed ) {
      // Try to minimize operations if there is only one group
      if ( match.length === 1 ) {

         // Take a shortcut and set the context if the root selector is an ID
         tokens = match[0] = match[0].slice( 0 );
         if ( tokens.length > 2 && (token = tokens[0]).type === "ID" &&
               context.nodeType === 9 && !xml &&
               Expr.relative[ tokens[1].type ] ) {

            context = Expr.find["ID"]( token.matches[0].replace( rbackslash, "" ), context, xml )[0];
            if ( !context ) {
               return results;
            }

            selector = selector.slice( tokens.shift().length );
         }

         // Fetch a seed set for right-to-left matching
         for ( i = matchExpr["POS"].test( selector ) ? -1 : tokens.length - 1; i >= 0; i-- ) {
            token = tokens[i];

            // Abort if we hit a combinator
            if ( Expr.relative[ (type = token.type) ] ) {
               break;
            }
            if ( (find = Expr.find[ type ]) ) {
               // Search, expanding context for leading sibling combinators
               if ( (seed = find(
                  token.matches[0].replace( rbackslash, "" ),
                  rsibling.test( tokens[0].type ) && context.parentNode || context,
                  xml
               )) ) {

                  // If seed is empty or no tokens remain, we can return early
                  tokens.splice( i, 1 );
                  selector = seed.length && tokens.join("");
                  if ( !selector ) {
                     push.apply( results, slice.call( seed, 0 ) );
                     return results;
                  }

                  break;
               }
            }
         }
      }
   }

   // Compile and execute a filtering function
   // Provide `match` to avoid retokenization if we modified the selector above
   compile( selector, match )(
      seed,
      context,
      xml,
      results,
      rsibling.test( selector )
   );
   return results;
}

if ( document.querySelectorAll ) {
   (function() {
      var disconnectedMatch,
         oldSelect = select,
         rescape = /'|\\/g,
         rattributeQuotes = /\=[\x20\t\r\n\f]*([^'"\]]*)[\x20\t\r\n\f]*\]/g,

         // qSa(:focus) reports false when true (Chrome 21),
         // A support test would require too much code (would include document ready)
         rbuggyQSA = [":focus"],

         // matchesSelector(:focus) reports false when true (Chrome 21),
         // matchesSelector(:active) reports false when true (IE9/Opera 11.5)
         // A support test would require too much code (would include document ready)
         // just skip matchesSelector for :active
         rbuggyMatches = [ ":active", ":focus" ],
         matches = docElem.matchesSelector ||
            docElem.mozMatchesSelector ||
            docElem.webkitMatchesSelector ||
            docElem.oMatchesSelector ||
            docElem.msMatchesSelector;

      // Build QSA regex
      // Regex strategy adopted from Diego Perini
      assert(function( div ) {
         // Select is set to empty string on purpose
         // This is to test IE's treatment of not explictly
         // setting a boolean content attribute,
         // since its presence should be enough
         // http://bugs.jquery.com/ticket/12359
         div.innerHTML = "<select><option selected=''></option></select>";

         // IE8 - Some boolean attributes are not treated correctly
         if ( !div.querySelectorAll("[selected]").length ) {
            rbuggyQSA.push( "\\[" + whitespace + "*(?:checked|disabled|ismap|multiple|readonly|selected|value)" );
         }

         // Webkit/Opera - :checked should return selected option elements
         // http://www.w3.org/TR/2011/REC-css3-selectors-20110929/#checked
         // IE8 throws error here (do not put tests after this one)
         if ( !div.querySelectorAll(":checked").length ) {
            rbuggyQSA.push(":checked");
         }
      });

      assert(function( div ) {

         // Opera 10-12/IE9 - ^= $= *= and empty values
         // Should not select anything
         div.innerHTML = "<p test=''></p>";
         if ( div.querySelectorAll("[test^='']").length ) {
            rbuggyQSA.push( "[*^$]=" + whitespace + "*(?:\"\"|'')" );
         }

         // FF 3.5 - :enabled/:disabled and hidden elements (hidden elements are still enabled)
         // IE8 throws error here (do not put tests after this one)
         div.innerHTML = "<input type='hidden'/>";
         if ( !div.querySelectorAll(":enabled").length ) {
            rbuggyQSA.push(":enabled", ":disabled");
         }
      });

      // rbuggyQSA always contains :focus, so no need for a length check
      rbuggyQSA = /* rbuggyQSA.length && */ new RegExp( rbuggyQSA.join("|") );

      select = function( selector, context, results, seed, xml ) {
         // Only use querySelectorAll when not filtering,
         // when this is not xml,
         // and when no QSA bugs apply
         if ( !seed && !xml && (!rbuggyQSA || !rbuggyQSA.test( selector )) ) {
            var groups, i,
               old = true,
               nid = expando,
               newContext = context,
               newSelector = context.nodeType === 9 && selector;

            // qSA works strangely on Element-rooted queries
            // We can work around this by specifying an extra ID on the root
            // and working up from there (Thanks to Andrew Dupont for the technique)
            // IE 8 doesn't work on object elements
            if ( context.nodeType === 1 && context.nodeName.toLowerCase() !== "object" ) {
               groups = tokenize( selector );

               if ( (old = context.getAttribute("id")) ) {
                  nid = old.replace( rescape, "\\$&" );
               } else {
                  context.setAttribute( "id", nid );
               }
               nid = "[id='" + nid + "'] ";

               i = groups.length;
               while ( i-- ) {
                  groups[i] = nid + groups[i].join("");
               }
               newContext = rsibling.test( selector ) && context.parentNode || context;
               newSelector = groups.join(",");
            }

            if ( newSelector ) {
               try {
                  push.apply( results, slice.call( newContext.querySelectorAll(
                     newSelector
                  ), 0 ) );
                  return results;
               } catch(qsaError) {
               } finally {
                  if ( !old ) {
                     context.removeAttribute("id");
                  }
               }
            }
         }

         return oldSelect( selector, context, results, seed, xml );
      };

      if ( matches ) {
         assert(function( div ) {
            // Check to see if it's possible to do matchesSelector
            // on a disconnected node (IE 9)
            disconnectedMatch = matches.call( div, "div" );

            // This should fail with an exception
            // Gecko does not error, returns false instead
            try {
               matches.call( div, "[test!='']:sizzle" );
               rbuggyMatches.push( "!=", pseudos );
            } catch ( e ) {}
         });

         // rbuggyMatches always contains :active and :focus, so no need for a length check
         rbuggyMatches = /* rbuggyMatches.length && */ new RegExp( rbuggyMatches.join("|") );

         Sizzle.matchesSelector = function( elem, expr ) {
            // Make sure that attribute selectors are quoted
            expr = expr.replace( rattributeQuotes, "='$1']" );

            // rbuggyMatches always contains :active, so no need for an existence check
            if ( !isXML( elem ) && !rbuggyMatches.test( expr ) && (!rbuggyQSA || !rbuggyQSA.test( expr )) ) {
               try {
                  var ret = matches.call( elem, expr );

                  // IE 9's matchesSelector returns false on disconnected nodes
                  if ( ret || disconnectedMatch ||
                        // As well, disconnected nodes are said to be in a document
                        // fragment in IE 9
                        elem.document && elem.document.nodeType !== 11 ) {
                     return ret;
                  }
               } catch(e) {}
            }

            return Sizzle( expr, null, null, [ elem ] ).length > 0;
         };
      }
   })();
}

// Deprecated
Expr.pseudos["nth"] = Expr.pseudos["eq"];

// Back-compat
function setFilters() {}
Expr.filters = setFilters.prototype = Expr.pseudos;
Expr.setFilters = new setFilters();

// Override sizzle attribute retrieval
Sizzle.attr = jQuery.attr;
jQuery.find = Sizzle;
jQuery.expr = Sizzle.selectors;
jQuery.expr[":"] = jQuery.expr.pseudos;
jQuery.unique = Sizzle.uniqueSort;
jQuery.text = Sizzle.getText;
jQuery.isXMLDoc = Sizzle.isXML;
jQuery.contains = Sizzle.contains;


})( window );
var runtil = /Until$/,
   rparentsprev = /^(?:parents|prev(?:Until|All))/,
   isSimple = /^.[^:#\[\.,]*$/,
   rneedsContext = jQuery.expr.match.needsContext,
   // methods guaranteed to produce a unique set when starting from a unique set
   guaranteedUnique = {
      children: true,
      contents: true,
      next: true,
      prev: true
   };

jQuery.fn.extend({
   find: function( selector ) {
      var i, l, length, n, r, ret,
         self = this;

      if ( typeof selector !== "string" ) {
         return jQuery( selector ).filter(function() {
            for ( i = 0, l = self.length; i < l; i++ ) {
               if ( jQuery.contains( self[ i ], this ) ) {
                  return true;
               }
            }
         });
      }

      ret = this.pushStack( "", "find", selector );

      for ( i = 0, l = this.length; i < l; i++ ) {
         length = ret.length;
         jQuery.find( selector, this[i], ret );

         if ( i > 0 ) {
            // Make sure that the results are unique
            for ( n = length; n < ret.length; n++ ) {
               for ( r = 0; r < length; r++ ) {
                  if ( ret[r] === ret[n] ) {
                     ret.splice(n--, 1);
                     break;
                  }
               }
            }
         }
      }

      return ret;
   },

   has: function( target ) {
      var i,
         targets = jQuery( target, this ),
         len = targets.length;

      return this.filter(function() {
         for ( i = 0; i < len; i++ ) {
            if ( jQuery.contains( this, targets[i] ) ) {
               return true;
            }
         }
      });
   },

   not: function( selector ) {
      return this.pushStack( winnow(this, selector, false), "not", selector);
   },

   filter: function( selector ) {
      return this.pushStack( winnow(this, selector, true), "filter", selector );
   },

   is: function( selector ) {
      return !!selector && (
         typeof selector === "string" ?
            // If this is a positional/relative selector, check membership in the returned set
            // so $("p:first").is("p:last") won't return true for a doc with two "p".
            rneedsContext.test( selector ) ?
               jQuery( selector, this.context ).index( this[0] ) >= 0 :
               jQuery.filter( selector, this ).length > 0 :
            this.filter( selector ).length > 0 );
   },

   closest: function( selectors, context ) {
      var cur,
         i = 0,
         l = this.length,
         ret = [],
         pos = rneedsContext.test( selectors ) || typeof selectors !== "string" ?
            jQuery( selectors, context || this.context ) :
            0;

      for ( ; i < l; i++ ) {
         cur = this[i];

         while ( cur && cur.ownerDocument && cur !== context && cur.nodeType !== 11 ) {
            if ( pos ? pos.index(cur) > -1 : jQuery.find.matchesSelector(cur, selectors) ) {
               ret.push( cur );
               break;
            }
            cur = cur.parentNode;
         }
      }

      ret = ret.length > 1 ? jQuery.unique( ret ) : ret;

      return this.pushStack( ret, "closest", selectors );
   },

   // Determine the position of an element within
   // the matched set of elements
   index: function( elem ) {

      // No argument, return index in parent
      if ( !elem ) {
         return ( this[0] && this[0].parentNode ) ? this.prevAll().length : -1;
      }

      // index in selector
      if ( typeof elem === "string" ) {
         return jQuery.inArray( this[0], jQuery( elem ) );
      }

      // Locate the position of the desired element
      return jQuery.inArray(
         // If it receives a jQuery object, the first element is used
         elem.jquery ? elem[0] : elem, this );
   },

   add: function( selector, context ) {
      var set = typeof selector === "string" ?
            jQuery( selector, context ) :
            jQuery.makeArray( selector && selector.nodeType ? [ selector ] : selector ),
         all = jQuery.merge( this.get(), set );

      return this.pushStack( isDisconnected( set[0] ) || isDisconnected( all[0] ) ?
         all :
         jQuery.unique( all ) );
   },

   addBack: function( selector ) {
      return this.add( selector == null ?
         this.prevObject : this.prevObject.filter(selector)
      );
   }
});

jQuery.fn.andSelf = jQuery.fn.addBack;

// A painfully simple check to see if an element is disconnected
// from a document (should be improved, where feasible).
function isDisconnected( node ) {
   return !node || !node.parentNode || node.parentNode.nodeType === 11;
}

function sibling( cur, dir ) {
   do {
      cur = cur[ dir ];
   } while ( cur && cur.nodeType !== 1 );

   return cur;
}

jQuery.each({
   parent: function( elem ) {
      var parent = elem.parentNode;
      return parent && parent.nodeType !== 11 ? parent : null;
   },
   parents: function( elem ) {
      return jQuery.dir( elem, "parentNode" );
   },
   parentsUntil: function( elem, i, until ) {
      return jQuery.dir( elem, "parentNode", until );
   },
   next: function( elem ) {
      return sibling( elem, "nextSibling" );
   },
   prev: function( elem ) {
      return sibling( elem, "previousSibling" );
   },
   nextAll: function( elem ) {
      return jQuery.dir( elem, "nextSibling" );
   },
   prevAll: function( elem ) {
      return jQuery.dir( elem, "previousSibling" );
   },
   nextUntil: function( elem, i, until ) {
      return jQuery.dir( elem, "nextSibling", until );
   },
   prevUntil: function( elem, i, until ) {
      return jQuery.dir( elem, "previousSibling", until );
   },
   siblings: function( elem ) {
      return jQuery.sibling( ( elem.parentNode || {} ).firstChild, elem );
   },
   children: function( elem ) {
      return jQuery.sibling( elem.firstChild );
   },
   contents: function( elem ) {
      return jQuery.nodeName( elem, "iframe" ) ?
         elem.contentDocument || elem.contentWindow.document :
         jQuery.merge( [], elem.childNodes );
   }
}, function( name, fn ) {
   jQuery.fn[ name ] = function( until, selector ) {
      var ret = jQuery.map( this, fn, until );

      if ( !runtil.test( name ) ) {
         selector = until;
      }

      if ( selector && typeof selector === "string" ) {
         ret = jQuery.filter( selector, ret );
      }

      ret = this.length > 1 && !guaranteedUnique[ name ] ? jQuery.unique( ret ) : ret;

      if ( this.length > 1 && rparentsprev.test( name ) ) {
         ret = ret.reverse();
      }

      return this.pushStack( ret, name, core_slice.call( arguments ).join(",") );
   };
});

jQuery.extend({
   filter: function( expr, elems, not ) {
      if ( not ) {
         expr = ":not(" + expr + ")";
      }

      return elems.length === 1 ?
         jQuery.find.matchesSelector(elems[0], expr) ? [ elems[0] ] : [] :
         jQuery.find.matches(expr, elems);
   },

   dir: function( elem, dir, until ) {
      var matched = [],
         cur = elem[ dir ];

      while ( cur && cur.nodeType !== 9 && (until === undefined || cur.nodeType !== 1 || !jQuery( cur ).is( until )) ) {
         if ( cur.nodeType === 1 ) {
            matched.push( cur );
         }
         cur = cur[dir];
      }
      return matched;
   },

   sibling: function( n, elem ) {
      var r = [];

      for ( ; n; n = n.nextSibling ) {
         if ( n.nodeType === 1 && n !== elem ) {
            r.push( n );
         }
      }

      return r;
   }
});

// Implement the identical functionality for filter and not
function winnow( elements, qualifier, keep ) {

   // Can't pass null or undefined to indexOf in Firefox 4
   // Set to 0 to skip string check
   qualifier = qualifier || 0;

   if ( jQuery.isFunction( qualifier ) ) {
      return jQuery.grep(elements, function( elem, i ) {
         var retVal = !!qualifier.call( elem, i, elem );
         return retVal === keep;
      });

   } else if ( qualifier.nodeType ) {
      return jQuery.grep(elements, function( elem, i ) {
         return ( elem === qualifier ) === keep;
      });

   } else if ( typeof qualifier === "string" ) {
      var filtered = jQuery.grep(elements, function( elem ) {
         return elem.nodeType === 1;
      });

      if ( isSimple.test( qualifier ) ) {
         return jQuery.filter(qualifier, filtered, !keep);
      } else {
         qualifier = jQuery.filter( qualifier, filtered );
      }
   }

   return jQuery.grep(elements, function( elem, i ) {
      return ( jQuery.inArray( elem, qualifier ) >= 0 ) === keep;
   });
}
function createSafeFragment( document ) {
   var list = nodeNames.split( "|" ),
   safeFrag = document.createDocumentFragment();

   if ( safeFrag.createElement ) {
      while ( list.length ) {
         safeFrag.createElement(
            list.pop()
         );
      }
   }
   return safeFrag;
}

var nodeNames = "abbr|article|aside|audio|bdi|canvas|data|datalist|details|figcaption|figure|footer|" +
      "header|hgroup|mark|meter|nav|output|progress|section|summary|time|video",
   rinlinejQuery = / jQuery\d+="(?:null|\d+)"/g,
   rleadingWhitespace = /^\s+/,
   rxhtmlTag = /<(?!area|br|col|embed|hr|img|input|link|meta|param)(([\w:]+)[^>]*)\/>/gi,
   rtagName = /<([\w:]+)/,
   rtbody = /<tbody/i,
   rhtml = /<|&#?\w+;/,
   rnoInnerhtml = /<(?:script|style|link)/i,
   rnocache = /<(?:script|object|embed|option|style)/i,
   rnoshimcache = new RegExp("<(?:" + nodeNames + ")[\\s/>]", "i"),
   rcheckableType = /^(?:checkbox|radio)$/,
   // checked="checked" or checked
   rchecked = /checked\s*(?:[^=]|=\s*.checked.)/i,
   rscriptType = /\/(java|ecma)script/i,
   rcleanScript = /^\s*<!(?:\[CDATA\[|\-\-)|[\]\-]{2}>\s*$/g,
   wrapMap = {
      option: [ 1, "<select multiple='multiple'>", "</select>" ],
      legend: [ 1, "<fieldset>", "</fieldset>" ],
      thead: [ 1, "<table>", "</table>" ],
      tr: [ 2, "<table><tbody>", "</tbody></table>" ],
      td: [ 3, "<table><tbody><tr>", "</tr></tbody></table>" ],
      col: [ 2, "<table><tbody></tbody><colgroup>", "</colgroup></table>" ],
      area: [ 1, "<map>", "</map>" ],
      _default: [ 0, "", "" ]
   },
   safeFragment = createSafeFragment( document ),
   fragmentDiv = safeFragment.appendChild( document.createElement("div") );

wrapMap.optgroup = wrapMap.option;
wrapMap.tbody = wrapMap.tfoot = wrapMap.colgroup = wrapMap.caption = wrapMap.thead;
wrapMap.th = wrapMap.td;

// IE6-8 can't serialize link, script, style, or any html5 (NoScope) tags,
// unless wrapped in a div with non-breaking characters in front of it.
if ( !jQuery.support.htmlSerialize ) {
   wrapMap._default = [ 1, "X<div>", "</div>" ];
}

jQuery.fn.extend({
   text: function( value ) {
      return jQuery.access( this, function( value ) {
         return value === undefined ?
            jQuery.text( this ) :
            this.empty().append( ( this[0] && this[0].ownerDocument || document ).createTextNode( value ) );
      }, null, value, arguments.length );
   },

   wrapAll: function( html ) {
      if ( jQuery.isFunction( html ) ) {
         return this.each(function(i) {
            jQuery(this).wrapAll( html.call(this, i) );
         });
      }

      if ( this[0] ) {
         // The elements to wrap the target around
         var wrap = jQuery( html, this[0].ownerDocument ).eq(0).clone(true);

         if ( this[0].parentNode ) {
            wrap.insertBefore( this[0] );
         }

         wrap.map(function() {
            var elem = this;

            while ( elem.firstChild && elem.firstChild.nodeType === 1 ) {
               elem = elem.firstChild;
            }

            return elem;
         }).append( this );
      }

      return this;
   },

   wrapInner: function( html ) {
      if ( jQuery.isFunction( html ) ) {
         return this.each(function(i) {
            jQuery(this).wrapInner( html.call(this, i) );
         });
      }

      return this.each(function() {
         var self = jQuery( this ),
            contents = self.contents();

         if ( contents.length ) {
            contents.wrapAll( html );

         } else {
            self.append( html );
         }
      });
   },

   wrap: function( html ) {
      var isFunction = jQuery.isFunction( html );

      return this.each(function(i) {
         jQuery( this ).wrapAll( isFunction ? html.call(this, i) : html );
      });
   },

   unwrap: function() {
      return this.parent().each(function() {
         if ( !jQuery.nodeName( this, "body" ) ) {
            jQuery( this ).replaceWith( this.childNodes );
         }
      }).end();
   },

   append: function() {
      return this.domManip(arguments, true, function( elem ) {
         if ( this.nodeType === 1 || this.nodeType === 11 ) {
            this.appendChild( elem );
         }
      });
   },

   prepend: function() {
      return this.domManip(arguments, true, function( elem ) {
         if ( this.nodeType === 1 || this.nodeType === 11 ) {
            this.insertBefore( elem, this.firstChild );
         }
      });
   },

   before: function() {
      if ( !isDisconnected( this[0] ) ) {
         return this.domManip(arguments, false, function( elem ) {
            this.parentNode.insertBefore( elem, this );
         });
      }

      if ( arguments.length ) {
         var set = jQuery.clean( arguments );
         return this.pushStack( jQuery.merge( set, this ), "before", this.selector );
      }
   },

   after: function() {
      if ( !isDisconnected( this[0] ) ) {
         return this.domManip(arguments, false, function( elem ) {
            this.parentNode.insertBefore( elem, this.nextSibling );
         });
      }

      if ( arguments.length ) {
         var set = jQuery.clean( arguments );
         return this.pushStack( jQuery.merge( this, set ), "after", this.selector );
      }
   },

   // keepData is for internal use only--do not document
   remove: function( selector, keepData ) {
      var elem,
         i = 0;

      for ( ; (elem = this[i]) != null; i++ ) {
         if ( !selector || jQuery.filter( selector, [ elem ] ).length ) {
            if ( !keepData && elem.nodeType === 1 ) {
               jQuery.cleanData( elem.getElementsByTagName("*") );
               jQuery.cleanData( [ elem ] );
            }

            if ( elem.parentNode ) {
               elem.parentNode.removeChild( elem );
            }
         }
      }

      return this;
   },

   empty: function() {
      var elem,
         i = 0;

      for ( ; (elem = this[i]) != null; i++ ) {
         // Remove element nodes and prevent memory leaks
         if ( elem.nodeType === 1 ) {
            jQuery.cleanData( elem.getElementsByTagName("*") );
         }

         // Remove any remaining nodes
         while ( elem.firstChild ) {
            elem.removeChild( elem.firstChild );
         }
      }

      return this;
   },

   clone: function( dataAndEvents, deepDataAndEvents ) {
      dataAndEvents = dataAndEvents == null ? false : dataAndEvents;
      deepDataAndEvents = deepDataAndEvents == null ? dataAndEvents : deepDataAndEvents;

      return this.map( function () {
         return jQuery.clone( this, dataAndEvents, deepDataAndEvents );
      });
   },

   html: function( value ) {
      return jQuery.access( this, function( value ) {
         var elem = this[0] || {},
            i = 0,
            l = this.length;

         if ( value === undefined ) {
            return elem.nodeType === 1 ?
               elem.innerHTML.replace( rinlinejQuery, "" ) :
               undefined;
         }

         // See if we can take a shortcut and just use innerHTML
         if ( typeof value === "string" && !rnoInnerhtml.test( value ) &&
            ( jQuery.support.htmlSerialize || !rnoshimcache.test( value )  ) &&
            ( jQuery.support.leadingWhitespace || !rleadingWhitespace.test( value ) ) &&
            !wrapMap[ ( rtagName.exec( value ) || ["", ""] )[1].toLowerCase() ] ) {

            value = value.replace( rxhtmlTag, "<$1></$2>" );

            try {
               for (; i < l; i++ ) {
                  // Remove element nodes and prevent memory leaks
                  elem = this[i] || {};
                  if ( elem.nodeType === 1 ) {
                     jQuery.cleanData( elem.getElementsByTagName( "*" ) );
                     elem.innerHTML = value;
                  }
               }

               elem = 0;

            // If using innerHTML throws an exception, use the fallback method
            } catch(e) {}
         }

         if ( elem ) {
            this.empty().append( value );
         }
      }, null, value, arguments.length );
   },

   replaceWith: function( value ) {
      if ( !isDisconnected( this[0] ) ) {
         // Make sure that the elements are removed from the DOM before they are inserted
         // this can help fix replacing a parent with child elements
         if ( jQuery.isFunction( value ) ) {
            return this.each(function(i) {
               var self = jQuery(this), old = self.html();
               self.replaceWith( value.call( this, i, old ) );
            });
         }

         if ( typeof value !== "string" ) {
            value = jQuery( value ).detach();
         }

         return this.each(function() {
            var next = this.nextSibling,
               parent = this.parentNode;

            jQuery( this ).remove();

            if ( next ) {
               jQuery(next).before( value );
            } else {
               jQuery(parent).append( value );
            }
         });
      }

      return this.length ?
         this.pushStack( jQuery(jQuery.isFunction(value) ? value() : value), "replaceWith", value ) :
         this;
   },

   detach: function( selector ) {
      return this.remove( selector, true );
   },

   domManip: function( args, table, callback ) {

      // Flatten any nested arrays
      args = [].concat.apply( [], args );

      var results, first, fragment, iNoClone,
         i = 0,
         value = args[0],
         scripts = [],
         l = this.length;

      // We can't cloneNode fragments that contain checked, in WebKit
      if ( !jQuery.support.checkClone && l > 1 && typeof value === "string" && rchecked.test( value ) ) {
         return this.each(function() {
            jQuery(this).domManip( args, table, callback );
         });
      }

      if ( jQuery.isFunction(value) ) {
         return this.each(function(i) {
            var self = jQuery(this);
            args[0] = value.call( this, i, table ? self.html() : undefined );
            self.domManip( args, table, callback );
         });
      }

      if ( this[0] ) {
         results = jQuery.buildFragment( args, this, scripts );
         fragment = results.fragment;
         first = fragment.firstChild;

         if ( fragment.childNodes.length === 1 ) {
            fragment = first;
         }

         if ( first ) {
            table = table && jQuery.nodeName( first, "tr" );

            // Use the original fragment for the last item instead of the first because it can end up
            // being emptied incorrectly in certain situations (#8070).
            // Fragments from the fragment cache must always be cloned and never used in place.
            for ( iNoClone = results.cacheable || l - 1; i < l; i++ ) {
               callback.call(
                  table && jQuery.nodeName( this[i], "table" ) ?
                     findOrAppend( this[i], "tbody" ) :
                     this[i],
                  i === iNoClone ?
                     fragment :
                     jQuery.clone( fragment, true, true )
               );
            }
         }

         // Fix #11809: Avoid leaking memory
         fragment = first = null;

         if ( scripts.length ) {
            jQuery.each( scripts, function( i, elem ) {
               if ( elem.src ) {
                  if ( jQuery.ajax ) {
                     jQuery.ajax({
                        url: elem.src,
                        type: "GET",
                        dataType: "script",
                        async: false,
                        global: false,
                        "throws": true
                     });
                  } else {
                     jQuery.error("no ajax");
                  }
               } else {
                  jQuery.globalEval( ( elem.text || elem.textContent || elem.innerHTML || "" ).replace( rcleanScript, "" ) );
               }

               if ( elem.parentNode ) {
                  elem.parentNode.removeChild( elem );
               }
            });
         }
      }

      return this;
   }
});

function findOrAppend( elem, tag ) {
   return elem.getElementsByTagName( tag )[0] || elem.appendChild( elem.ownerDocument.createElement( tag ) );
}

function cloneCopyEvent( src, dest ) {

   if ( dest.nodeType !== 1 || !jQuery.hasData( src ) ) {
      return;
   }

   var type, i, l,
      oldData = jQuery._data( src ),
      curData = jQuery._data( dest, oldData ),
      events = oldData.events;

   if ( events ) {
      delete curData.handle;
      curData.events = {};

      for ( type in events ) {
         for ( i = 0, l = events[ type ].length; i < l; i++ ) {
            jQuery.event.add( dest, type, events[ type ][ i ] );
         }
      }
   }

   // make the cloned public data object a copy from the original
   if ( curData.data ) {
      curData.data = jQuery.extend( {}, curData.data );
   }
}

function cloneFixAttributes( src, dest ) {
   var nodeName;

   // We do not need to do anything for non-Elements
   if ( dest.nodeType !== 1 ) {
      return;
   }

   // clearAttributes removes the attributes, which we don't want,
   // but also removes the attachEvent events, which we *do* want
   if ( dest.clearAttributes ) {
      dest.clearAttributes();
   }

   // mergeAttributes, in contrast, only merges back on the
   // original attributes, not the events
   if ( dest.mergeAttributes ) {
      dest.mergeAttributes( src );
   }

   nodeName = dest.nodeName.toLowerCase();

   if ( nodeName === "object" ) {
      // IE6-10 improperly clones children of object elements using classid.
      // IE10 throws NoModificationAllowedError if parent is null, #12132.
      if ( dest.parentNode ) {
         dest.outerHTML = src.outerHTML;
      }

      // This path appears unavoidable for IE9. When cloning an object
      // element in IE9, the outerHTML strategy above is not sufficient.
      // If the src has innerHTML and the destination does not,
      // copy the src.innerHTML into the dest.innerHTML. #10324
      if ( jQuery.support.html5Clone && (src.innerHTML && !jQuery.trim(dest.innerHTML)) ) {
         dest.innerHTML = src.innerHTML;
      }

   } else if ( nodeName === "input" && rcheckableType.test( src.type ) ) {
      // IE6-8 fails to persist the checked state of a cloned checkbox
      // or radio button. Worse, IE6-7 fail to give the cloned element
      // a checked appearance if the defaultChecked value isn't also set

      dest.defaultChecked = dest.checked = src.checked;

      // IE6-7 get confused and end up setting the value of a cloned
      // checkbox/radio button to an empty string instead of "on"
      if ( dest.value !== src.value ) {
         dest.value = src.value;
      }

   // IE6-8 fails to return the selected option to the default selected
   // state when cloning options
   } else if ( nodeName === "option" ) {
      dest.selected = src.defaultSelected;

   // IE6-8 fails to set the defaultValue to the correct value when
   // cloning other types of input fields
   } else if ( nodeName === "input" || nodeName === "textarea" ) {
      dest.defaultValue = src.defaultValue;

   // IE blanks contents when cloning scripts
   } else if ( nodeName === "script" && dest.text !== src.text ) {
      dest.text = src.text;
   }

   // Event data gets referenced instead of copied if the expando
   // gets copied too
   dest.removeAttribute( jQuery.expando );
}

jQuery.buildFragment = function( args, context, scripts ) {
   var fragment, cacheable, cachehit,
      first = args[ 0 ];

   // Set context from what may come in as undefined or a jQuery collection or a node
   // Updated to fix #12266 where accessing context[0] could throw an exception in IE9/10 &
   // also doubles as fix for #8950 where plain objects caused createDocumentFragment exception
   context = context || document;
   context = !context.nodeType && context[0] || context;
   context = context.ownerDocument || context;

   // Only cache "small" (1/2 KB) HTML strings that are associated with the main document
   // Cloning options loses the selected state, so don't cache them
   // IE 6 doesn't like it when you put <object> or <embed> elements in a fragment
   // Also, WebKit does not clone 'checked' attributes on cloneNode, so don't cache
   // Lastly, IE6,7,8 will not correctly reuse cached fragments that were created from unknown elems #10501
   if ( args.length === 1 && typeof first === "string" && first.length < 512 && context === document &&
      first.charAt(0) === "<" && !rnocache.test( first ) &&
      (jQuery.support.checkClone || !rchecked.test( first )) &&
      (jQuery.support.html5Clone || !rnoshimcache.test( first )) ) {

      // Mark cacheable and look for a hit
      cacheable = true;
      fragment = jQuery.fragments[ first ];
      cachehit = fragment !== undefined;
   }

   if ( !fragment ) {
      fragment = context.createDocumentFragment();
      jQuery.clean( args, context, fragment, scripts );

      // Update the cache, but only store false
      // unless this is a second parsing of the same content
      if ( cacheable ) {
         jQuery.fragments[ first ] = cachehit && fragment;
      }
   }

   return { fragment: fragment, cacheable: cacheable };
};

jQuery.fragments = {};

jQuery.each({
   appendTo: "append",
   prependTo: "prepend",
   insertBefore: "before",
   insertAfter: "after",
   replaceAll: "replaceWith"
}, function( name, original ) {
   jQuery.fn[ name ] = function( selector ) {
      var elems,
         i = 0,
         ret = [],
         insert = jQuery( selector ),
         l = insert.length,
         parent = this.length === 1 && this[0].parentNode;

      if ( (parent == null || parent && parent.nodeType === 11 && parent.childNodes.length === 1) && l === 1 ) {
         insert[ original ]( this[0] );
         return this;
      } else {
         for ( ; i < l; i++ ) {
            elems = ( i > 0 ? this.clone(true) : this ).get();
            jQuery( insert[i] )[ original ]( elems );
            ret = ret.concat( elems );
         }

         return this.pushStack( ret, name, insert.selector );
      }
   };
});

function getAll( elem ) {
   if ( typeof elem.getElementsByTagName !== "undefined" ) {
      return elem.getElementsByTagName( "*" );

   } else if ( typeof elem.querySelectorAll !== "undefined" ) {
      return elem.querySelectorAll( "*" );

   } else {
      return [];
   }
}

// Used in clean, fixes the defaultChecked property
function fixDefaultChecked( elem ) {
   if ( rcheckableType.test( elem.type ) ) {
      elem.defaultChecked = elem.checked;
   }
}

jQuery.extend({
   clone: function( elem, dataAndEvents, deepDataAndEvents ) {
      var srcElements,
         destElements,
         i,
         clone;

      if ( jQuery.support.html5Clone || jQuery.isXMLDoc(elem) || !rnoshimcache.test( "<" + elem.nodeName + ">" ) ) {
         clone = elem.cloneNode( true );

      // IE<=8 does not properly clone detached, unknown element nodes
      } else {
         fragmentDiv.innerHTML = elem.outerHTML;
         fragmentDiv.removeChild( clone = fragmentDiv.firstChild );
      }

      if ( (!jQuery.support.noCloneEvent || !jQuery.support.noCloneChecked) &&
            (elem.nodeType === 1 || elem.nodeType === 11) && !jQuery.isXMLDoc(elem) ) {
         // IE copies events bound via attachEvent when using cloneNode.
         // Calling detachEvent on the clone will also remove the events
         // from the original. In order to get around this, we use some
         // proprietary methods to clear the events. Thanks to MooTools
         // guys for this hotness.

         cloneFixAttributes( elem, clone );

         // Using Sizzle here is crazy slow, so we use getElementsByTagName instead
         srcElements = getAll( elem );
         destElements = getAll( clone );

         // Weird iteration because IE will replace the length property
         // with an element if you are cloning the body and one of the
         // elements on the page has a name or id of "length"
         for ( i = 0; srcElements[i]; ++i ) {
            // Ensure that the destination node is not null; Fixes #9587
            if ( destElements[i] ) {
               cloneFixAttributes( srcElements[i], destElements[i] );
            }
         }
      }

      // Copy the events from the original to the clone
      if ( dataAndEvents ) {
         cloneCopyEvent( elem, clone );

         if ( deepDataAndEvents ) {
            srcElements = getAll( elem );
            destElements = getAll( clone );

            for ( i = 0; srcElements[i]; ++i ) {
               cloneCopyEvent( srcElements[i], destElements[i] );
            }
         }
      }

      srcElements = destElements = null;

      // Return the cloned set
      return clone;
   },

   clean: function( elems, context, fragment, scripts ) {
      var i, j, elem, tag, wrap, depth, div, hasBody, tbody, len, handleScript, jsTags,
         safe = context === document && safeFragment,
         ret = [];

      // Ensure that context is a document
      if ( !context || typeof context.createDocumentFragment === "undefined" ) {
         context = document;
      }

      // Use the already-created safe fragment if context permits
      for ( i = 0; (elem = elems[i]) != null; i++ ) {
         if ( typeof elem === "number" ) {
            elem += "";
         }

         if ( !elem ) {
            continue;
         }

         // Convert html string into DOM nodes
         if ( typeof elem === "string" ) {
            if ( !rhtml.test( elem ) ) {
               elem = context.createTextNode( elem );
            } else {
               // Ensure a safe container in which to render the html
               safe = safe || createSafeFragment( context );
               div = context.createElement("div");
               safe.appendChild( div );

               // Fix "XHTML"-style tags in all browsers
               elem = elem.replace(rxhtmlTag, "<$1></$2>");

               // Go to html and back, then peel off extra wrappers
               tag = ( rtagName.exec( elem ) || ["", ""] )[1].toLowerCase();
               wrap = wrapMap[ tag ] || wrapMap._default;
               depth = wrap[0];
               div.innerHTML = wrap[1] + elem + wrap[2];

               // Move to the right depth
               while ( depth-- ) {
                  div = div.lastChild;
               }

               // Remove IE's autoinserted <tbody> from table fragments
               if ( !jQuery.support.tbody ) {

                  // String was a <table>, *may* have spurious <tbody>
                  hasBody = rtbody.test(elem);
                     tbody = tag === "table" && !hasBody ?
                        div.firstChild && div.firstChild.childNodes :

                        // String was a bare <thead> or <tfoot>
                        wrap[1] === "<table>" && !hasBody ?
                           div.childNodes :
                           [];

                  for ( j = tbody.length - 1; j >= 0 ; --j ) {
                     if ( jQuery.nodeName( tbody[ j ], "tbody" ) && !tbody[ j ].childNodes.length ) {
                        tbody[ j ].parentNode.removeChild( tbody[ j ] );
                     }
                  }
               }

               // IE completely kills leading whitespace when innerHTML is used
               if ( !jQuery.support.leadingWhitespace && rleadingWhitespace.test( elem ) ) {
                  div.insertBefore( context.createTextNode( rleadingWhitespace.exec(elem)[0] ), div.firstChild );
               }

               elem = div.childNodes;

               // Take out of fragment container (we need a fresh div each time)
               div.parentNode.removeChild( div );
            }
         }

         if ( elem.nodeType ) {
            ret.push( elem );
         } else {
            jQuery.merge( ret, elem );
         }
      }

      // Fix #11356: Clear elements from safeFragment
      if ( div ) {
         elem = div = safe = null;
      }

      // Reset defaultChecked for any radios and checkboxes
      // about to be appended to the DOM in IE 6/7 (#8060)
      if ( !jQuery.support.appendChecked ) {
         for ( i = 0; (elem = ret[i]) != null; i++ ) {
            if ( jQuery.nodeName( elem, "input" ) ) {
               fixDefaultChecked( elem );
            } else if ( typeof elem.getElementsByTagName !== "undefined" ) {
               jQuery.grep( elem.getElementsByTagName("input"), fixDefaultChecked );
            }
         }
      }

      // Append elements to a provided document fragment
      if ( fragment ) {
         // Special handling of each script element
         handleScript = function( elem ) {
            // Check if we consider it executable
            if ( !elem.type || rscriptType.test( elem.type ) ) {
               // Detach the script and store it in the scripts array (if provided) or the fragment
               // Return truthy to indicate that it has been handled
               return scripts ?
                  scripts.push( elem.parentNode ? elem.parentNode.removeChild( elem ) : elem ) :
                  fragment.appendChild( elem );
            }
         };

         for ( i = 0; (elem = ret[i]) != null; i++ ) {
            // Check if we're done after handling an executable script
            if ( !( jQuery.nodeName( elem, "script" ) && handleScript( elem ) ) ) {
               // Append to fragment and handle embedded scripts
               fragment.appendChild( elem );
               if ( typeof elem.getElementsByTagName !== "undefined" ) {
                  // handleScript alters the DOM, so use jQuery.merge to ensure snapshot iteration
                  jsTags = jQuery.grep( jQuery.merge( [], elem.getElementsByTagName("script") ), handleScript );

                  // Splice the scripts into ret after their former ancestor and advance our index beyond them
                  ret.splice.apply( ret, [i + 1, 0].concat( jsTags ) );
                  i += jsTags.length;
               }
            }
         }
      }

      return ret;
   },

   cleanData: function( elems, /* internal */ acceptData ) {
      var data, id, elem, type,
         i = 0,
         internalKey = jQuery.expando,
         cache = jQuery.cache,
         deleteExpando = jQuery.support.deleteExpando,
         special = jQuery.event.special;

      for ( ; (elem = elems[i]) != null; i++ ) {

         if ( acceptData || jQuery.acceptData( elem ) ) {

            id = elem[ internalKey ];
            data = id && cache[ id ];

            if ( data ) {
               if ( data.events ) {
                  for ( type in data.events ) {
                     if ( special[ type ] ) {
                        jQuery.event.remove( elem, type );

                     // This is a shortcut to avoid jQuery.event.remove's overhead
                     } else {
                        jQuery.removeEvent( elem, type, data.handle );
                     }
                  }
               }

               // Remove cache only if it was not already removed by jQuery.event.remove
               if ( cache[ id ] ) {

                  delete cache[ id ];

                  // IE does not allow us to delete expando properties from nodes,
                  // nor does it have a removeAttribute function on Document nodes;
                  // we must handle all of these cases
                  if ( deleteExpando ) {
                     delete elem[ internalKey ];

                  } else if ( elem.removeAttribute ) {
                     elem.removeAttribute( internalKey );

                  } else {
                     elem[ internalKey ] = null;
                  }

                  jQuery.deletedIds.push( id );
               }
            }
         }
      }
   }
});
// Limit scope pollution from any deprecated API
(function() {

var matched, browser;

// Use of jQuery.browser is frowned upon.
// More details: http://api.jquery.com/jQuery.browser
// jQuery.uaMatch maintained for back-compat
jQuery.uaMatch = function( ua ) {
   ua = ua.toLowerCase();

   var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
      /(webkit)[ \/]([\w.]+)/.exec( ua ) ||
      /(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
      /(msie) ([\w.]+)/.exec( ua ) ||
      ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
      [];

   return {
      browser: match[ 1 ] || "",
      version: match[ 2 ] || "0"
   };
};

matched = jQuery.uaMatch( navigator.userAgent );
browser = {};

if ( matched.browser ) {
   browser[ matched.browser ] = true;
   browser.version = matched.version;
}

// Chrome is Webkit, but Webkit is also Safari.
if ( browser.chrome ) {
   browser.webkit = true;
} else if ( browser.webkit ) {
   browser.safari = true;
}

jQuery.browser = browser;

jQuery.sub = function() {
   function jQuerySub( selector, context ) {
      return new jQuerySub.fn.init( selector, context );
   }
   jQuery.extend( true, jQuerySub, this );
   jQuerySub.superclass = this;
   jQuerySub.fn = jQuerySub.prototype = this();
   jQuerySub.fn.constructor = jQuerySub;
   jQuerySub.sub = this.sub;
   jQuerySub.fn.init = function init( selector, context ) {
      if ( context && context instanceof jQuery && !(context instanceof jQuerySub) ) {
         context = jQuerySub( context );
      }

      return jQuery.fn.init.call( this, selector, context, rootjQuerySub );
   };
   jQuerySub.fn.init.prototype = jQuerySub.fn;
   var rootjQuerySub = jQuerySub(document);
   return jQuerySub;
};

})();
var curCSS, iframe, iframeDoc,
   ralpha = /alpha\([^)]*\)/i,
   ropacity = /opacity=([^)]*)/,
   rposition = /^(top|right|bottom|left)$/,
   // swappable if display is none or starts with table except "table", "table-cell", or "table-caption"
   // see here for display values: https://developer.mozilla.org/en-US/docs/CSS/display
   rdisplayswap = /^(none|table(?!-c[ea]).+)/,
   rmargin = /^margin/,
   rnumsplit = new RegExp( "^(" + core_pnum + ")(.*)$", "i" ),
   rnumnonpx = new RegExp( "^(" + core_pnum + ")(?!px)[a-z%]+$", "i" ),
   rrelNum = new RegExp( "^([-+])=(" + core_pnum + ")", "i" ),
   elemdisplay = {},

   cssShow = { position: "absolute", visibility: "hidden", display: "block" },
   cssNormalTransform = {
      letterSpacing: 0,
      fontWeight: 400
   },

   cssExpand = [ "Top", "Right", "Bottom", "Left" ],
   cssPrefixes = [ "Webkit", "O", "Moz", "ms" ],

   eventsToggle = jQuery.fn.toggle;

// return a css property mapped to a potentially vendor prefixed property
function vendorPropName( style, name ) {

   // shortcut for names that are not vendor prefixed
   if ( name in style ) {
      return name;
   }

   // check for vendor prefixed names
   var capName = name.charAt(0).toUpperCase() + name.slice(1),
      origName = name,
      i = cssPrefixes.length;

   while ( i-- ) {
      name = cssPrefixes[ i ] + capName;
      if ( name in style ) {
         return name;
      }
   }

   return origName;
}

function isHidden( elem, el ) {
   elem = el || elem;
   return jQuery.css( elem, "display" ) === "none" || !jQuery.contains( elem.ownerDocument, elem );
}

function showHide( elements, show ) {
   var elem, display,
      values = [],
      index = 0,
      length = elements.length;

   for ( ; index < length; index++ ) {
      elem = elements[ index ];
      if ( !elem.style ) {
         continue;
      }
      values[ index ] = jQuery._data( elem, "olddisplay" );
      if ( show ) {
         // Reset the inline display of this element to learn if it is
         // being hidden by cascaded rules or not
         if ( !values[ index ] && elem.style.display === "none" ) {
            elem.style.display = "";
         }

         // Set elements which have been overridden with display: none
         // in a stylesheet to whatever the default browser style is
         // for such an element
         if ( elem.style.display === "" && isHidden( elem ) ) {
            values[ index ] = jQuery._data( elem, "olddisplay", css_defaultDisplay(elem.nodeName) );
         }
      } else {
         display = curCSS( elem, "display" );

         if ( !values[ index ] && display !== "none" ) {
            jQuery._data( elem, "olddisplay", display );
         }
      }
   }

   // Set the display of most of the elements in a second loop
   // to avoid the constant reflow
   for ( index = 0; index < length; index++ ) {
      elem = elements[ index ];
      if ( !elem.style ) {
         continue;
      }
      if ( !show || elem.style.display === "none" || elem.style.display === "" ) {
         elem.style.display = show ? values[ index ] || "" : "none";
      }
   }

   return elements;
}

jQuery.fn.extend({
   css: function( name, value ) {
      return jQuery.access( this, function( elem, name, value ) {
         return value !== undefined ?
            jQuery.style( elem, name, value ) :
            jQuery.css( elem, name );
      }, name, value, arguments.length > 1 );
   },
   show: function() {
      return showHide( this, true );
   },
   hide: function() {
      return showHide( this );
   },
   toggle: function( state, fn2 ) {
      var bool = typeof state === "boolean";

      if ( jQuery.isFunction( state ) && jQuery.isFunction( fn2 ) ) {
         return eventsToggle.apply( this, arguments );
      }

      return this.each(function() {
         if ( bool ? state : isHidden( this ) ) {
            jQuery( this ).show();
         } else {
            jQuery( this ).hide();
         }
      });
   }
});

jQuery.extend({
   // Add in style property hooks for overriding the default
   // behavior of getting and setting a style property
   cssHooks: {
      opacity: {
         get: function( elem, computed ) {
            if ( computed ) {
               // We should always get a number back from opacity
               var ret = curCSS( elem, "opacity" );
               return ret === "" ? "1" : ret;

            }
         }
      }
   },

   // Exclude the following css properties to add px
   cssNumber: {
      "fillOpacity": true,
      "fontWeight": true,
      "lineHeight": true,
      "opacity": true,
      "orphans": true,
      "widows": true,
      "zIndex": true,
      "zoom": true
   },

   // Add in properties whose names you wish to fix before
   // setting or getting the value
   cssProps: {
      // normalize float css property
      "float": jQuery.support.cssFloat ? "cssFloat" : "styleFloat"
   },

   // Get and set the style property on a DOM Node
   style: function( elem, name, value, extra ) {
      // Don't set styles on text and comment nodes
      if ( !elem || elem.nodeType === 3 || elem.nodeType === 8 || !elem.style ) {
         return;
      }

      // Make sure that we're working with the right name
      var ret, type, hooks,
         origName = jQuery.camelCase( name ),
         style = elem.style;

      name = jQuery.cssProps[ origName ] || ( jQuery.cssProps[ origName ] = vendorPropName( style, origName ) );

      // gets hook for the prefixed version
      // followed by the unprefixed version
      hooks = jQuery.cssHooks[ name ] || jQuery.cssHooks[ origName ];

      // Check if we're setting a value
      if ( value !== undefined ) {
         type = typeof value;

         // convert relative number strings (+= or -=) to relative numbers. #7345
         if ( type === "string" && (ret = rrelNum.exec( value )) ) {
            value = ( ret[1] + 1 ) * ret[2] + parseFloat( jQuery.css( elem, name ) );
            // Fixes bug #9237
            type = "number";
         }

         // Make sure that NaN and null values aren't set. See: #7116
         if ( value == null || type === "number" && isNaN( value ) ) {
            return;
         }

         // If a number was passed in, add 'px' to the (except for certain CSS properties)
         if ( type === "number" && !jQuery.cssNumber[ origName ] ) {
            value += "px";
         }

         // If a hook was provided, use that value, otherwise just set the specified value
         if ( !hooks || !("set" in hooks) || (value = hooks.set( elem, value, extra )) !== undefined ) {
            // Wrapped to prevent IE from throwing errors when 'invalid' values are provided
            // Fixes bug #5509
            try {
               style[ name ] = value;
            } catch(e) {}
         }

      } else {
         // If a hook was provided get the non-computed value from there
         if ( hooks && "get" in hooks && (ret = hooks.get( elem, false, extra )) !== undefined ) {
            return ret;
         }

         // Otherwise just get the value from the style object
         return style[ name ];
      }
   },

   css: function( elem, name, numeric, extra ) {
      var val, num, hooks,
         origName = jQuery.camelCase( name );

      // Make sure that we're working with the right name
      name = jQuery.cssProps[ origName ] || ( jQuery.cssProps[ origName ] = vendorPropName( elem.style, origName ) );

      // gets hook for the prefixed version
      // followed by the unprefixed version
      hooks = jQuery.cssHooks[ name ] || jQuery.cssHooks[ origName ];

      // If a hook was provided get the computed value from there
      if ( hooks && "get" in hooks ) {
         val = hooks.get( elem, true, extra );
      }

      // Otherwise, if a way to get the computed value exists, use that
      if ( val === undefined ) {
         val = curCSS( elem, name );
      }

      //convert "normal" to computed value
      if ( val === "normal" && name in cssNormalTransform ) {
         val = cssNormalTransform[ name ];
      }

      // Return, converting to number if forced or a qualifier was provided and val looks numeric
      if ( numeric || extra !== undefined ) {
         num = parseFloat( val );
         return numeric || jQuery.isNumeric( num ) ? num || 0 : val;
      }
      return val;
   },

   // A method for quickly swapping in/out CSS properties to get correct calculations
   swap: function( elem, options, callback ) {
      var ret, name,
         old = {};

      // Remember the old values, and insert the new ones
      for ( name in options ) {
         old[ name ] = elem.style[ name ];
         elem.style[ name ] = options[ name ];
      }

      ret = callback.call( elem );

      // Revert the old values
      for ( name in options ) {
         elem.style[ name ] = old[ name ];
      }

      return ret;
   }
});

// NOTE: To any future maintainer, we've window.getComputedStyle
// because jsdom on node.js will break without it.
if ( window.getComputedStyle ) {
   curCSS = function( elem, name ) {
      var ret, width, minWidth, maxWidth,
         computed = window.getComputedStyle( elem, null ),
         style = elem.style;

      if ( computed ) {

         ret = computed[ name ];
         if ( ret === "" && !jQuery.contains( elem.ownerDocument, elem ) ) {
            ret = jQuery.style( elem, name );
         }

         // A tribute to the "awesome hack by Dean Edwards"
         // Chrome < 17 and Safari 5.0 uses "computed value" instead of "used value" for margin-right
         // Safari 5.1.7 (at least) returns percentage for a larger set of values, but width seems to be reliably pixels
         // this is against the CSSOM draft spec: http://dev.w3.org/csswg/cssom/#resolved-values
         if ( rnumnonpx.test( ret ) && rmargin.test( name ) ) {
            width = style.width;
            minWidth = style.minWidth;
            maxWidth = style.maxWidth;

            style.minWidth = style.maxWidth = style.width = ret;
            ret = computed.width;

            style.width = width;
            style.minWidth = minWidth;
            style.maxWidth = maxWidth;
         }
      }

      return ret;
   };
} else if ( document.documentElement.currentStyle ) {
   curCSS = function( elem, name ) {
      var left, rsLeft,
         ret = elem.currentStyle && elem.currentStyle[ name ],
         style = elem.style;

      // Avoid setting ret to empty string here
      // so we don't default to auto
      if ( ret == null && style && style[ name ] ) {
         ret = style[ name ];
      }

      // From the awesome hack by Dean Edwards
      // http://erik.eae.net/archives/2007/07/27/18.54.15/#comment-102291

      // If we're not dealing with a regular pixel number
      // but a number that has a weird ending, we need to convert it to pixels
      // but not position css attributes, as those are proportional to the parent element instead
      // and we can't measure the parent instead because it might trigger a "stacking dolls" problem
      if ( rnumnonpx.test( ret ) && !rposition.test( name ) ) {

         // Remember the original values
         left = style.left;
         rsLeft = elem.runtimeStyle && elem.runtimeStyle.left;

         // Put in the new values to get a computed value out
         if ( rsLeft ) {
            elem.runtimeStyle.left = elem.currentStyle.left;
         }
         style.left = name === "fontSize" ? "1em" : ret;
         ret = style.pixelLeft + "px";

         // Revert the changed values
         style.left = left;
         if ( rsLeft ) {
            elem.runtimeStyle.left = rsLeft;
         }
      }

      return ret === "" ? "auto" : ret;
   };
}

function setPositiveNumber( elem, value, subtract ) {
   var matches = rnumsplit.exec( value );
   return matches ?
         Math.max( 0, matches[ 1 ] - ( subtract || 0 ) ) + ( matches[ 2 ] || "px" ) :
         value;
}

function augmentWidthOrHeight( elem, name, extra, isBorderBox ) {
   var i = extra === ( isBorderBox ? "border" : "content" ) ?
      // If we already have the right measurement, avoid augmentation
      4 :
      // Otherwise initialize for horizontal or vertical properties
      name === "width" ? 1 : 0,

      val = 0;

   for ( ; i < 4; i += 2 ) {
      // both box models exclude margin, so add it if we want it
      if ( extra === "margin" ) {
         // we use jQuery.css instead of curCSS here
         // because of the reliableMarginRight CSS hook!
         val += jQuery.css( elem, extra + cssExpand[ i ], true );
      }

      // From this point on we use curCSS for maximum performance (relevant in animations)
      if ( isBorderBox ) {
         // border-box includes padding, so remove it if we want content
         if ( extra === "content" ) {
            val -= parseFloat( curCSS( elem, "padding" + cssExpand[ i ] ) ) || 0;
         }

         // at this point, extra isn't border nor margin, so remove border
         if ( extra !== "margin" ) {
            val -= parseFloat( curCSS( elem, "border" + cssExpand[ i ] + "Width" ) ) || 0;
         }
      } else {
         // at this point, extra isn't content, so add padding
         val += parseFloat( curCSS( elem, "padding" + cssExpand[ i ] ) ) || 0;

         // at this point, extra isn't content nor padding, so add border
         if ( extra !== "padding" ) {
            val += parseFloat( curCSS( elem, "border" + cssExpand[ i ] + "Width" ) ) || 0;
         }
      }
   }

   return val;
}

function getWidthOrHeight( elem, name, extra ) {

   // Start with offset property, which is equivalent to the border-box value
   var val = name === "width" ? elem.offsetWidth : elem.offsetHeight,
      valueIsBorderBox = true,
      isBorderBox = jQuery.support.boxSizing && jQuery.css( elem, "boxSizing" ) === "border-box";

   // some non-html elements return undefined for offsetWidth, so check for null/undefined
   // svg - https://bugzilla.mozilla.org/show_bug.cgi?id=649285
   // MathML - https://bugzilla.mozilla.org/show_bug.cgi?id=491668
   if ( val <= 0 || val == null ) {
      // Fall back to computed then uncomputed css if necessary
      val = curCSS( elem, name );
      if ( val < 0 || val == null ) {
         val = elem.style[ name ];
      }

      // Computed unit is not pixels. Stop here and return.
      if ( rnumnonpx.test(val) ) {
         return val;
      }

      // we need the check for style in case a browser which returns unreliable values
      // for getComputedStyle silently falls back to the reliable elem.style
      valueIsBorderBox = isBorderBox && ( jQuery.support.boxSizingReliable || val === elem.style[ name ] );

      // Normalize "", auto, and prepare for extra
      val = parseFloat( val ) || 0;
   }

   // use the active box-sizing model to add/subtract irrelevant styles
   return ( val +
      augmentWidthOrHeight(
         elem,
         name,
         extra || ( isBorderBox ? "border" : "content" ),
         valueIsBorderBox
      )
   ) + "px";
}


// Try to determine the default display value of an element
function css_defaultDisplay( nodeName ) {
   if ( elemdisplay[ nodeName ] ) {
      return elemdisplay[ nodeName ];
   }

   var elem = jQuery( "<" + nodeName + ">" ).appendTo( document.body ),
      display = elem.css("display");
   elem.remove();

   // If the simple way fails,
   // get element's real default display by attaching it to a temp iframe
   if ( display === "none" || display === "" ) {
      // Use the already-created iframe if possible
      iframe = document.body.appendChild(
         iframe || jQuery.extend( document.createElement("iframe"), {
            frameBorder: 0,
            width: 0,
            height: 0
         })
      );

      // Create a cacheable copy of the iframe document on first call.
      // IE and Opera will allow us to reuse the iframeDoc without re-writing the fake HTML
      // document to it; WebKit & Firefox won't allow reusing the iframe document.
      if ( !iframeDoc || !iframe.createElement ) {
         iframeDoc = ( iframe.contentWindow || iframe.contentDocument ).document;
         iframeDoc.write("<!doctype html><html><body>");
         iframeDoc.close();
      }

      elem = iframeDoc.body.appendChild( iframeDoc.createElement(nodeName) );

      display = curCSS( elem, "display" );
      document.body.removeChild( iframe );
   }

   // Store the correct default display
   elemdisplay[ nodeName ] = display;

   return display;
}

jQuery.each([ "height", "width" ], function( i, name ) {
   jQuery.cssHooks[ name ] = {
      get: function( elem, computed, extra ) {
         if ( computed ) {
            // certain elements can have dimension info if we invisibly show them
            // however, it must have a current display style that would benefit from this
            if ( elem.offsetWidth === 0 && rdisplayswap.test( curCSS( elem, "display" ) ) ) {
               return jQuery.swap( elem, cssShow, function() {
                  return getWidthOrHeight( elem, name, extra );
               });
            } else {
               return getWidthOrHeight( elem, name, extra );
            }
         }
      },

      set: function( elem, value, extra ) {
         return setPositiveNumber( elem, value, extra ?
            augmentWidthOrHeight(
               elem,
               name,
               extra,
               jQuery.support.boxSizing && jQuery.css( elem, "boxSizing" ) === "border-box"
            ) : 0
         );
      }
   };
});

if ( !jQuery.support.opacity ) {
   jQuery.cssHooks.opacity = {
      get: function( elem, computed ) {
         // IE uses filters for opacity
         return ropacity.test( (computed && elem.currentStyle ? elem.currentStyle.filter : elem.style.filter) || "" ) ?
            ( 0.01 * parseFloat( RegExp.$1 ) ) + "" :
            computed ? "1" : "";
      },

      set: function( elem, value ) {
         var style = elem.style,
            currentStyle = elem.currentStyle,
            opacity = jQuery.isNumeric( value ) ? "alpha(opacity=" + value * 100 + ")" : "",
            filter = currentStyle && currentStyle.filter || style.filter || "";

         // IE has trouble with opacity if it does not have layout
         // Force it by setting the zoom level
         style.zoom = 1;

         // if setting opacity to 1, and no other filters exist - attempt to remove filter attribute #6652
         if ( value >= 1 && jQuery.trim( filter.replace( ralpha, "" ) ) === "" &&
            style.removeAttribute ) {

            // Setting style.filter to null, "" & " " still leave "filter:" in the cssText
            // if "filter:" is present at all, clearType is disabled, we want to avoid this
            // style.removeAttribute is IE Only, but so apparently is this code path...
            style.removeAttribute( "filter" );

            // if there there is no filter style applied in a css rule, we are done
            if ( currentStyle && !currentStyle.filter ) {
               return;
            }
         }

         // otherwise, set new filter values
         style.filter = ralpha.test( filter ) ?
            filter.replace( ralpha, opacity ) :
            filter + " " + opacity;
      }
   };
}

// These hooks cannot be added until DOM ready because the support test
// for it is not run until after DOM ready
jQuery(function() {
   if ( !jQuery.support.reliableMarginRight ) {
      jQuery.cssHooks.marginRight = {
         get: function( elem, computed ) {
            // WebKit Bug 13343 - getComputedStyle returns wrong value for margin-right
            // Work around by temporarily setting element display to inline-block
            return jQuery.swap( elem, { "display": "inline-block" }, function() {
               if ( computed ) {
                  return curCSS( elem, "marginRight" );
               }
            });
         }
      };
   }

   // Webkit bug: https://bugs.webkit.org/show_bug.cgi?id=29084
   // getComputedStyle returns percent when specified for top/left/bottom/right
   // rather than make the css module depend on the offset module, we just check for it here
   if ( !jQuery.support.pixelPosition && jQuery.fn.position ) {
      jQuery.each( [ "top", "left" ], function( i, prop ) {
         jQuery.cssHooks[ prop ] = {
            get: function( elem, computed ) {
               if ( computed ) {
                  var ret = curCSS( elem, prop );
                  // if curCSS returns percentage, fallback to offset
                  return rnumnonpx.test( ret ) ? jQuery( elem ).position()[ prop ] + "px" : ret;
               }
            }
         };
      });
   }

});

if ( jQuery.expr && jQuery.expr.filters ) {
   jQuery.expr.filters.hidden = function( elem ) {
      return ( elem.offsetWidth === 0 && elem.offsetHeight === 0 ) || (!jQuery.support.reliableHiddenOffsets && ((elem.style && elem.style.display) || curCSS( elem, "display" )) === "none");
   };

   jQuery.expr.filters.visible = function( elem ) {
      return !jQuery.expr.filters.hidden( elem );
   };
}

// These hooks are used by animate to expand properties
jQuery.each({
   margin: "",
   padding: "",
   border: "Width"
}, function( prefix, suffix ) {
   jQuery.cssHooks[ prefix + suffix ] = {
      expand: function( value ) {
         var i,

            // assumes a single number if not a string
            parts = typeof value === "string" ? value.split(" ") : [ value ],
            expanded = {};

         for ( i = 0; i < 4; i++ ) {
            expanded[ prefix + cssExpand[ i ] + suffix ] =
               parts[ i ] || parts[ i - 2 ] || parts[ 0 ];
         }

         return expanded;
      }
   };

   if ( !rmargin.test( prefix ) ) {
      jQuery.cssHooks[ prefix + suffix ].set = setPositiveNumber;
   }
});
var r20 = /%20/g,
   rbracket = /\[\]$/,
   rCRLF = /\r?\n/g,
   rinput = /^(?:color|date|datetime|datetime-local|email|hidden|month|number|password|range|search|tel|text|time|url|week)$/i,
   rselectTextarea = /^(?:select|textarea)/i;

jQuery.fn.extend({
   serialize: function() {
      return jQuery.param( this.serializeArray() );
   },
   serializeArray: function() {
      return this.map(function(){
         return this.elements ? jQuery.makeArray( this.elements ) : this;
      })
      .filter(function(){
         return this.name && !this.disabled &&
            ( this.checked || rselectTextarea.test( this.nodeName ) ||
               rinput.test( this.type ) );
      })
      .map(function( i, elem ){
         var val = jQuery( this ).val();

         return val == null ?
            null :
            jQuery.isArray( val ) ?
               jQuery.map( val, function( val, i ){
                  return { name: elem.name, value: val.replace( rCRLF, "\r\n" ) };
               }) :
               { name: elem.name, value: val.replace( rCRLF, "\r\n" ) };
      }).get();
   }
});

//Serialize an array of form elements or a set of
//key/values into a query string
jQuery.param = function( a, traditional ) {
   var prefix,
      s = [],
      add = function( key, value ) {
         // If value is a function, invoke it and return its value
         value = jQuery.isFunction( value ) ? value() : ( value == null ? "" : value );
         s[ s.length ] = encodeURIComponent( key ) + "=" + encodeURIComponent( value );
      };

   // Set traditional to true for jQuery <= 1.3.2 behavior.
   if ( traditional === undefined ) {
      traditional = jQuery.ajaxSettings && jQuery.ajaxSettings.traditional;
   }

   // If an array was passed in, assume that it is an array of form elements.
   if ( jQuery.isArray( a ) || ( a.jquery && !jQuery.isPlainObject( a ) ) ) {
      // Serialize the form elements
      jQuery.each( a, function() {
         add( this.name, this.value );
      });

   } else {
      // If traditional, encode the "old" way (the way 1.3.2 or older
      // did it), otherwise encode params recursively.
      for ( prefix in a ) {
         buildParams( prefix, a[ prefix ], traditional, add );
      }
   }

   // Return the resulting serialization
   return s.join( "&" ).replace( r20, "+" );
};

function buildParams( prefix, obj, traditional, add ) {
   var name;

   if ( jQuery.isArray( obj ) ) {
      // Serialize array item.
      jQuery.each( obj, function( i, v ) {
         if ( traditional || rbracket.test( prefix ) ) {
            // Treat each array item as a scalar.
            add( prefix, v );

         } else {
            // If array item is non-scalar (array or object), encode its
            // numeric index to resolve deserialization ambiguity issues.
            // Note that rack (as of 1.0.0) can't currently deserialize
            // nested arrays properly, and attempting to do so may cause
            // a server error. Possible fixes are to modify rack's
            // deserialization algorithm or to provide an option or flag
            // to force array serialization to be shallow.
            buildParams( prefix + "[" + ( typeof v === "object" ? i : "" ) + "]", v, traditional, add );
         }
      });

   } else if ( !traditional && jQuery.type( obj ) === "object" ) {
      // Serialize object item.
      for ( name in obj ) {
         buildParams( prefix + "[" + name + "]", obj[ name ], traditional, add );
      }

   } else {
      // Serialize scalar item.
      add( prefix, obj );
   }
}
var
   // Document location
   ajaxLocParts,
   ajaxLocation,

   rhash = /#.*$/,
   rheaders = /^(.*?):[ \t]*([^\r\n]*)\r?$/mg, // IE leaves an \r character at EOL
   // #7653, #8125, #8152: local protocol detection
   rlocalProtocol = /^(?:about|app|app\-storage|.+\-extension|file|res|widget):$/,
   rnoContent = /^(?:GET|HEAD)$/,
   rprotocol = /^\/\//,
   rquery = /\?/,
   rscript = /<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi,
   rts = /([?&])_=[^&]*/,
   rurl = /^([\w\+\.\-]+:)(?:\/\/([^\/?#:]*)(?::(\d+)|)|)/,

   // Keep a copy of the old load method
   _load = jQuery.fn.load,

   /* Prefilters
    * 1) They are useful to introduce custom dataTypes (see ajax/jsonp.js for an example)
    * 2) These are called:
    *    - BEFORE asking for a transport
    *    - AFTER param serialization (s.data is a string if s.processData is true)
    * 3) key is the dataType
    * 4) the catchall symbol "*" can be used
    * 5) execution will start with transport dataType and THEN continue down to "*" if needed
    */
   prefilters = {},

   /* Transports bindings
    * 1) key is the dataType
    * 2) the catchall symbol "*" can be used
    * 3) selection will start with transport dataType and THEN go to "*" if needed
    */
   transports = {},

   // Avoid comment-prolog char sequence (#10098); must appease lint and evade compression
   allTypes = ["*/"] + ["*"];

// #8138, IE may throw an exception when accessing
// a field from window.location if document.domain has been set
try {
   ajaxLocation = location.href;
} catch( e ) {
   // Use the href attribute of an A element
   // since IE will modify it given document.location
   ajaxLocation = document.createElement( "a" );
   ajaxLocation.href = "";
   ajaxLocation = ajaxLocation.href;
}

// Segment location into parts
ajaxLocParts = rurl.exec( ajaxLocation.toLowerCase() ) || [];

// Base "constructor" for jQuery.ajaxPrefilter and jQuery.ajaxTransport
function addToPrefiltersOrTransports( structure ) {

   // dataTypeExpression is optional and defaults to "*"
   return function( dataTypeExpression, func ) {

      if ( typeof dataTypeExpression !== "string" ) {
         func = dataTypeExpression;
         dataTypeExpression = "*";
      }

      var dataType, list, placeBefore,
         dataTypes = dataTypeExpression.toLowerCase().split( core_rspace ),
         i = 0,
         length = dataTypes.length;

      if ( jQuery.isFunction( func ) ) {
         // For each dataType in the dataTypeExpression
         for ( ; i < length; i++ ) {
            dataType = dataTypes[ i ];
            // We control if we're asked to add before
            // any existing element
            placeBefore = /^\+/.test( dataType );
            if ( placeBefore ) {
               dataType = dataType.substr( 1 ) || "*";
            }
            list = structure[ dataType ] = structure[ dataType ] || [];
            // then we add to the structure accordingly
            list[ placeBefore ? "unshift" : "push" ]( func );
         }
      }
   };
}

// Base inspection function for prefilters and transports
function inspectPrefiltersOrTransports( structure, options, originalOptions, jqXHR,
      dataType /* internal */, inspected /* internal */ ) {

   dataType = dataType || options.dataTypes[ 0 ];
   inspected = inspected || {};

   inspected[ dataType ] = true;

   var selection,
      list = structure[ dataType ],
      i = 0,
      length = list ? list.length : 0,
      executeOnly = ( structure === prefilters );

   for ( ; i < length && ( executeOnly || !selection ); i++ ) {
      selection = list[ i ]( options, originalOptions, jqXHR );
      // If we got redirected to another dataType
      // we try there if executing only and not done already
      if ( typeof selection === "string" ) {
         if ( !executeOnly || inspected[ selection ] ) {
            selection = undefined;
         } else {
            options.dataTypes.unshift( selection );
            selection = inspectPrefiltersOrTransports(
                  structure, options, originalOptions, jqXHR, selection, inspected );
         }
      }
   }
   // If we're only executing or nothing was selected
   // we try the catchall dataType if not done already
   if ( ( executeOnly || !selection ) && !inspected[ "*" ] ) {
      selection = inspectPrefiltersOrTransports(
            structure, options, originalOptions, jqXHR, "*", inspected );
   }
   // unnecessary when only executing (prefilters)
   // but it'll be ignored by the caller in that case
   return selection;
}

// A special extend for ajax options
// that takes "flat" options (not to be deep extended)
// Fixes #9887
function ajaxExtend( target, src ) {
   var key, deep,
      flatOptions = jQuery.ajaxSettings.flatOptions || {};
   for ( key in src ) {
      if ( src[ key ] !== undefined ) {
         ( flatOptions[ key ] ? target : ( deep || ( deep = {} ) ) )[ key ] = src[ key ];
      }
   }
   if ( deep ) {
      jQuery.extend( true, target, deep );
   }
}

jQuery.fn.load = function( url, params, callback ) {
   if ( typeof url !== "string" && _load ) {
      return _load.apply( this, arguments );
   }

   // Don't do a request if no elements are being requested
   if ( !this.length ) {
      return this;
   }

   var selector, type, response,
      self = this,
      off = url.indexOf(" ");

   if ( off >= 0 ) {
      selector = url.slice( off, url.length );
      url = url.slice( 0, off );
   }

   // If it's a function
   if ( jQuery.isFunction( params ) ) {

      // We assume that it's the callback
      callback = params;
      params = undefined;

   // Otherwise, build a param string
   } else if ( params && typeof params === "object" ) {
      type = "POST";
   }

   // Request the remote document
   jQuery.ajax({
      url: url,

      // if "type" variable is undefined, then "GET" method will be used
      type: type,
      dataType: "html",
      data: params,
      complete: function( jqXHR, status ) {
         if ( callback ) {
            self.each( callback, response || [ jqXHR.responseText, status, jqXHR ] );
         }
      }
   }).done(function( responseText ) {

      // Save response for use in complete callback
      response = arguments;

      // See if a selector was specified
      self.html( selector ?

         // Create a dummy div to hold the results
         jQuery("<div>")

            // inject the contents of the document in, removing the scripts
            // to avoid any 'Permission Denied' errors in IE
            .append( responseText.replace( rscript, "" ) )

            // Locate the specified elements
            .find( selector ) :

         // If not, just inject the full result
         responseText );

   });

   return this;
};

// Attach a bunch of functions for handling common AJAX events
jQuery.each( "ajaxStart ajaxStop ajaxComplete ajaxError ajaxSuccess ajaxSend".split( " " ), function( i, o ){
   jQuery.fn[ o ] = function( f ){
      return this.on( o, f );
   };
});

jQuery.each( [ "get", "post" ], function( i, method ) {
   jQuery[ method ] = function( url, data, callback, type ) {
      // shift arguments if data argument was omitted
      if ( jQuery.isFunction( data ) ) {
         type = type || callback;
         callback = data;
         data = undefined;
      }

      return jQuery.ajax({
         type: method,
         url: url,
         data: data,
         success: callback,
         dataType: type
      });
   };
});

jQuery.extend({

   getScript: function( url, callback ) {
      return jQuery.get( url, undefined, callback, "script" );
   },

   getJSON: function( url, data, callback ) {
      return jQuery.get( url, data, callback, "json" );
   },

   // Creates a full fledged settings object into target
   // with both ajaxSettings and settings fields.
   // If target is omitted, writes into ajaxSettings.
   ajaxSetup: function( target, settings ) {
      if ( settings ) {
         // Building a settings object
         ajaxExtend( target, jQuery.ajaxSettings );
      } else {
         // Extending ajaxSettings
         settings = target;
         target = jQuery.ajaxSettings;
      }
      ajaxExtend( target, settings );
      return target;
   },

   ajaxSettings: {
      url: ajaxLocation,
      isLocal: rlocalProtocol.test( ajaxLocParts[ 1 ] ),
      global: true,
      type: "GET",
      contentType: "application/x-www-form-urlencoded; charset=UTF-8",
      processData: true,
      async: true,
      /*
      timeout: 0,
      data: null,
      dataType: null,
      username: null,
      password: null,
      cache: null,
      throws: false,
      traditional: false,
      headers: {},
      */

      accepts: {
         xml: "application/xml, text/xml",
         html: "text/html",
         text: "text/plain",
         json: "application/json, text/javascript",
         "*": allTypes
      },

      contents: {
         xml: /xml/,
         html: /html/,
         json: /json/
      },

      responseFields: {
         xml: "responseXML",
         text: "responseText"
      },

      // List of data converters
      // 1) key format is "source_type destination_type" (a single space in-between)
      // 2) the catchall symbol "*" can be used for source_type
      converters: {

         // Convert anything to text
         "* text": window.String,

         // Text to html (true = no transformation)
         "text html": true,

         // Evaluate text as a json expression
         "text json": jQuery.parseJSON,

         // Parse text as xml
         "text xml": jQuery.parseXML
      },

      // For options that shouldn't be deep extended:
      // you can add your own custom options here if
      // and when you create one that shouldn't be
      // deep extended (see ajaxExtend)
      flatOptions: {
         context: true,
         url: true
      }
   },

   ajaxPrefilter: addToPrefiltersOrTransports( prefilters ),
   ajaxTransport: addToPrefiltersOrTransports( transports ),

   // Main method
   ajax: function( url, options ) {

      // If url is an object, simulate pre-1.5 signature
      if ( typeof url === "object" ) {
         options = url;
         url = undefined;
      }

      // Force options to be an object
      options = options || {};

      var // ifModified key
         ifModifiedKey,
         // Response headers
         responseHeadersString,
         responseHeaders,
         // transport
         transport,
         // timeout handle
         timeoutTimer,
         // Cross-domain detection vars
         parts,
         // To know if global events are to be dispatched
         fireGlobals,
         // Loop variable
         i,
         // Create the final options object
         s = jQuery.ajaxSetup( {}, options ),
         // Callbacks context
         callbackContext = s.context || s,
         // Context for global events
         // It's the callbackContext if one was provided in the options
         // and if it's a DOM node or a jQuery collection
         globalEventContext = callbackContext !== s &&
            ( callbackContext.nodeType || callbackContext instanceof jQuery ) ?
                  jQuery( callbackContext ) : jQuery.event,
         // Deferreds
         deferred = jQuery.Deferred(),
         completeDeferred = jQuery.Callbacks( "once memory" ),
         // Status-dependent callbacks
         statusCode = s.statusCode || {},
         // Headers (they are sent all at once)
         requestHeaders = {},
         requestHeadersNames = {},
         // The jqXHR state
         state = 0,
         // Default abort message
         strAbort = "canceled",
         // Fake xhr
         jqXHR = {

            readyState: 0,

            // Caches the header
            setRequestHeader: function( name, value ) {
               if ( !state ) {
                  var lname = name.toLowerCase();
                  name = requestHeadersNames[ lname ] = requestHeadersNames[ lname ] || name;
                  requestHeaders[ name ] = value;
               }
               return this;
            },

            // Raw string
            getAllResponseHeaders: function() {
               return state === 2 ? responseHeadersString : null;
            },

            // Builds headers hashtable if needed
            getResponseHeader: function( key ) {
               var match;
               if ( state === 2 ) {
                  if ( !responseHeaders ) {
                     responseHeaders = {};
                     while( ( match = rheaders.exec( responseHeadersString ) ) ) {
                        responseHeaders[ match[1].toLowerCase() ] = match[ 2 ];
                     }
                  }
                  match = responseHeaders[ key.toLowerCase() ];
               }
               return match === undefined ? null : match;
            },

            // Overrides response content-type header
            overrideMimeType: function( type ) {
               if ( !state ) {
                  s.mimeType = type;
               }
               return this;
            },

            // Cancel the request
            abort: function( statusText ) {
               statusText = statusText || strAbort;
               if ( transport ) {
                  transport.abort( statusText );
               }
               done( 0, statusText );
               return this;
            }
         };

      // Callback for when everything is done
      // It is defined here because jslint complains if it is declared
      // at the end of the function (which would be more logical and readable)
      function done( status, nativeStatusText, responses, headers ) {
         var isSuccess, success, error, response, modified,
            statusText = nativeStatusText;

         // Called once
         if ( state === 2 ) {
            return;
         }

         // State is "done" now
         state = 2;

         // Clear timeout if it exists
         if ( timeoutTimer ) {
            clearTimeout( timeoutTimer );
         }

         // Dereference transport for early garbage collection
         // (no matter how long the jqXHR object will be used)
         transport = undefined;

         // Cache response headers
         responseHeadersString = headers || "";

         // Set readyState
         jqXHR.readyState = status > 0 ? 4 : 0;

         // Get response data
         if ( responses ) {
            response = ajaxHandleResponses( s, jqXHR, responses );
         }

         // If successful, handle type chaining
         if ( status >= 200 && status < 300 || status === 304 ) {

            // Set the If-Modified-Since and/or If-None-Match header, if in ifModified mode.
            if ( s.ifModified ) {

               modified = jqXHR.getResponseHeader("Last-Modified");
               if ( modified ) {
                  jQuery.lastModified[ ifModifiedKey ] = modified;
               }
               modified = jqXHR.getResponseHeader("Etag");
               if ( modified ) {
                  jQuery.etag[ ifModifiedKey ] = modified;
               }
            }

            // If not modified
            if ( status === 304 ) {

               statusText = "notmodified";
               isSuccess = true;

            // If we have data
            } else {

               isSuccess = ajaxConvert( s, response );
               statusText = isSuccess.state;
               success = isSuccess.data;
               error = isSuccess.error;
               isSuccess = !error;
            }
         } else {
            // We extract error from statusText
            // then normalize statusText and status for non-aborts
            error = statusText;
            if ( !statusText || status ) {
               statusText = "error";
               if ( status < 0 ) {
                  status = 0;
               }
            }
         }

         // Set data for the fake xhr object
         jqXHR.status = status;
         jqXHR.statusText = ( nativeStatusText || statusText ) + "";

         // Success/Error
         if ( isSuccess ) {
            deferred.resolveWith( callbackContext, [ success, statusText, jqXHR ] );
         } else {
            deferred.rejectWith( callbackContext, [ jqXHR, statusText, error ] );
         }

         // Status-dependent callbacks
         jqXHR.statusCode( statusCode );
         statusCode = undefined;

         if ( fireGlobals ) {
            globalEventContext.trigger( "ajax" + ( isSuccess ? "Success" : "Error" ),
                  [ jqXHR, s, isSuccess ? success : error ] );
         }

         // Complete
         completeDeferred.fireWith( callbackContext, [ jqXHR, statusText ] );

         if ( fireGlobals ) {
            globalEventContext.trigger( "ajaxComplete", [ jqXHR, s ] );
            // Handle the global AJAX counter
            if ( !( --jQuery.active ) ) {
               jQuery.event.trigger( "ajaxStop" );
            }
         }
      }

      // Attach deferreds
      deferred.promise( jqXHR );
      jqXHR.success = jqXHR.done;
      jqXHR.error = jqXHR.fail;
      jqXHR.complete = completeDeferred.add;

      // Status-dependent callbacks
      jqXHR.statusCode = function( map ) {
         if ( map ) {
            var tmp;
            if ( state < 2 ) {
               for ( tmp in map ) {
                  statusCode[ tmp ] = [ statusCode[tmp], map[tmp] ];
               }
            } else {
               tmp = map[ jqXHR.status ];
               jqXHR.always( tmp );
            }
         }
         return this;
      };

      // Remove hash character (#7531: and string promotion)
      // Add protocol if not provided (#5866: IE7 issue with protocol-less urls)
      // We also use the url parameter if available
      s.url = ( ( url || s.url ) + "" ).replace( rhash, "" ).replace( rprotocol, ajaxLocParts[ 1 ] + "//" );

      // Extract dataTypes list
      s.dataTypes = jQuery.trim( s.dataType || "*" ).toLowerCase().split( core_rspace );

      // A cross-domain request is in order when we have a protocol:host:port mismatch
      if ( s.crossDomain == null ) {
         parts = rurl.exec( s.url.toLowerCase() ) || false;
         s.crossDomain = parts && ( parts.join(":") + ( parts[ 3 ] ? "" : parts[ 1 ] === "http:" ? 80 : 443 ) ) !==
            ( ajaxLocParts.join(":") + ( ajaxLocParts[ 3 ] ? "" : ajaxLocParts[ 1 ] === "http:" ? 80 : 443 ) );
      }

      // Convert data if not already a string
      if ( s.data && s.processData && typeof s.data !== "string" ) {
         s.data = jQuery.param( s.data, s.traditional );
      }

      // Apply prefilters
      inspectPrefiltersOrTransports( prefilters, s, options, jqXHR );

      // If request was aborted inside a prefilter, stop there
      if ( state === 2 ) {
         return jqXHR;
      }

      // We can fire global events as of now if asked to
      fireGlobals = s.global;

      // Uppercase the type
      s.type = s.type.toUpperCase();

      // Determine if request has content
      s.hasContent = !rnoContent.test( s.type );

      // Watch for a new set of requests
      if ( fireGlobals && jQuery.active++ === 0 ) {
         jQuery.event.trigger( "ajaxStart" );
      }

      // More options handling for requests with no content
      if ( !s.hasContent ) {

         // If data is available, append data to url
         if ( s.data ) {
            s.url += ( rquery.test( s.url ) ? "&" : "?" ) + s.data;
            // #9682: remove data so that it's not used in an eventual retry
            delete s.data;
         }

         // Get ifModifiedKey before adding the anti-cache parameter
         ifModifiedKey = s.url;

         // Add anti-cache in url if needed
         if ( s.cache === false ) {

            var ts = jQuery.now(),
               // try replacing _= if it is there
               ret = s.url.replace( rts, "$1_=" + ts );

            // if nothing was replaced, add timestamp to the end
            s.url = ret + ( ( ret === s.url ) ? ( rquery.test( s.url ) ? "&" : "?" ) + "_=" + ts : "" );
         }
      }

      // Set the correct header, if data is being sent
      if ( s.data && s.hasContent && s.contentType !== false || options.contentType ) {
         jqXHR.setRequestHeader( "Content-Type", s.contentType );
      }

      // Set the If-Modified-Since and/or If-None-Match header, if in ifModified mode.
      if ( s.ifModified ) {
         ifModifiedKey = ifModifiedKey || s.url;
         if ( jQuery.lastModified[ ifModifiedKey ] ) {
            jqXHR.setRequestHeader( "If-Modified-Since", jQuery.lastModified[ ifModifiedKey ] );
         }
         if ( jQuery.etag[ ifModifiedKey ] ) {
            jqXHR.setRequestHeader( "If-None-Match", jQuery.etag[ ifModifiedKey ] );
         }
      }

      // Set the Accepts header for the server, depending on the dataType
      jqXHR.setRequestHeader(
         "Accept",
         s.dataTypes[ 0 ] && s.accepts[ s.dataTypes[0] ] ?
            s.accepts[ s.dataTypes[0] ] + ( s.dataTypes[ 0 ] !== "*" ? ", " + allTypes + "; q=0.01" : "" ) :
            s.accepts[ "*" ]
      );

      // Check for headers option
      for ( i in s.headers ) {
         jqXHR.setRequestHeader( i, s.headers[ i ] );
      }

      // Allow custom headers/mimetypes and early abort
      if ( s.beforeSend && ( s.beforeSend.call( callbackContext, jqXHR, s ) === false || state === 2 ) ) {
            // Abort if not done already and return
            return jqXHR.abort();

      }

      // aborting is no longer a cancellation
      strAbort = "abort";

      // Install callbacks on deferreds
      for ( i in { success: 1, error: 1, complete: 1 } ) {
         jqXHR[ i ]( s[ i ] );
      }

      // Get transport
      transport = inspectPrefiltersOrTransports( transports, s, options, jqXHR );

      // If no transport, we auto-abort
      if ( !transport ) {
         done( -1, "No Transport" );
      } else {
         jqXHR.readyState = 1;
         // Send global event
         if ( fireGlobals ) {
            globalEventContext.trigger( "ajaxSend", [ jqXHR, s ] );
         }
         // Timeout
         if ( s.async && s.timeout > 0 ) {
            timeoutTimer = setTimeout( function(){
               jqXHR.abort( "timeout" );
            }, s.timeout );
         }

         try {
            state = 1;
            transport.send( requestHeaders, done );
         } catch (e) {
            // Propagate exception as error if not done
            if ( state < 2 ) {
               done( -1, e );
            // Simply rethrow otherwise
            } else {
               throw e;
            }
         }
      }

      return jqXHR;
   },

   // Counter for holding the number of active queries
   active: 0,

   // Last-Modified header cache for next request
   lastModified: {},
   etag: {}

});

/* Handles responses to an ajax request:
 * - sets all responseXXX fields accordingly
 * - finds the right dataType (mediates between content-type and expected dataType)
 * - returns the corresponding response
 */
function ajaxHandleResponses( s, jqXHR, responses ) {

   var ct, type, finalDataType, firstDataType,
      contents = s.contents,
      dataTypes = s.dataTypes,
      responseFields = s.responseFields;

   // Fill responseXXX fields
   for ( type in responseFields ) {
      if ( type in responses ) {
         jqXHR[ responseFields[type] ] = responses[ type ];
      }
   }

   // Remove auto dataType and get content-type in the process
   while( dataTypes[ 0 ] === "*" ) {
      dataTypes.shift();
      if ( ct === undefined ) {
         ct = s.mimeType || jqXHR.getResponseHeader( "content-type" );
      }
   }

   // Check if we're dealing with a known content-type
   if ( ct ) {
      for ( type in contents ) {
         if ( contents[ type ] && contents[ type ].test( ct ) ) {
            dataTypes.unshift( type );
            break;
         }
      }
   }

   // Check to see if we have a response for the expected dataType
   if ( dataTypes[ 0 ] in responses ) {
      finalDataType = dataTypes[ 0 ];
   } else {
      // Try convertible dataTypes
      for ( type in responses ) {
         if ( !dataTypes[ 0 ] || s.converters[ type + " " + dataTypes[0] ] ) {
            finalDataType = type;
            break;
         }
         if ( !firstDataType ) {
            firstDataType = type;
         }
      }
      // Or just use first one
      finalDataType = finalDataType || firstDataType;
   }

   // If we found a dataType
   // We add the dataType to the list if needed
   // and return the corresponding response
   if ( finalDataType ) {
      if ( finalDataType !== dataTypes[ 0 ] ) {
         dataTypes.unshift( finalDataType );
      }
      return responses[ finalDataType ];
   }
}

// Chain conversions given the request and the original response
function ajaxConvert( s, response ) {

   var conv, conv2, current, tmp,
      // Work with a copy of dataTypes in case we need to modify it for conversion
      dataTypes = s.dataTypes.slice(),
      prev = dataTypes[ 0 ],
      converters = {},
      i = 0;

   // Apply the dataFilter if provided
   if ( s.dataFilter ) {
      response = s.dataFilter( response, s.dataType );
   }

   // Create converters map with lowercased keys
   if ( dataTypes[ 1 ] ) {
      for ( conv in s.converters ) {
         converters[ conv.toLowerCase() ] = s.converters[ conv ];
      }
   }

   // Convert to each sequential dataType, tolerating list modification
   for ( ; (current = dataTypes[++i]); ) {

      // There's only work to do if current dataType is non-auto
      if ( current !== "*" ) {

         // Convert response if prev dataType is non-auto and differs from current
         if ( prev !== "*" && prev !== current ) {

            // Seek a direct converter
            conv = converters[ prev + " " + current ] || converters[ "* " + current ];

            // If none found, seek a pair
            if ( !conv ) {
               for ( conv2 in converters ) {

                  // If conv2 outputs current
                  tmp = conv2.split(" ");
                  if ( tmp[ 1 ] === current ) {

                     // If prev can be converted to accepted input
                     conv = converters[ prev + " " + tmp[ 0 ] ] ||
                        converters[ "* " + tmp[ 0 ] ];
                     if ( conv ) {
                        // Condense equivalence converters
                        if ( conv === true ) {
                           conv = converters[ conv2 ];

                        // Otherwise, insert the intermediate dataType
                        } else if ( converters[ conv2 ] !== true ) {
                           current = tmp[ 0 ];
                           dataTypes.splice( i--, 0, current );
                        }

                        break;
                     }
                  }
               }
            }

            // Apply converter (if not an equivalence)
            if ( conv !== true ) {

               // Unless errors are allowed to bubble, catch and return them
               if ( conv && s["throws"] ) {
                  response = conv( response );
               } else {
                  try {
                     response = conv( response );
                  } catch ( e ) {
                     return { state: "parsererror", error: conv ? e : "No conversion from " + prev + " to " + current };
                  }
               }
            }
         }

         // Update prev for next iteration
         prev = current;
      }
   }

   return { state: "success", data: response };
}
var oldCallbacks = [],
   rquestion = /\?/,
   rjsonp = /(=)\?(?=&|$)|\?\?/,
   nonce = jQuery.now();

// Default jsonp settings
jQuery.ajaxSetup({
   jsonp: "callback",
   jsonpCallback: function() {
      var callback = oldCallbacks.pop() || ( jQuery.expando + "_" + ( nonce++ ) );
      this[ callback ] = true;
      return callback;
   }
});

// Detect, normalize options and install callbacks for jsonp requests
jQuery.ajaxPrefilter( "json jsonp", function( s, originalSettings, jqXHR ) {

   var callbackName, overwritten, responseContainer,
      data = s.data,
      url = s.url,
      hasCallback = s.jsonp !== false,
      replaceInUrl = hasCallback && rjsonp.test( url ),
      replaceInData = hasCallback && !replaceInUrl && typeof data === "string" &&
         !( s.contentType || "" ).indexOf("application/x-www-form-urlencoded") &&
         rjsonp.test( data );

   // Handle iff the expected data type is "jsonp" or we have a parameter to set
   if ( s.dataTypes[ 0 ] === "jsonp" || replaceInUrl || replaceInData ) {

      // Get callback name, remembering preexisting value associated with it
      callbackName = s.jsonpCallback = jQuery.isFunction( s.jsonpCallback ) ?
         s.jsonpCallback() :
         s.jsonpCallback;
      overwritten = window[ callbackName ];

      // Insert callback into url or form data
      if ( replaceInUrl ) {
         s.url = url.replace( rjsonp, "$1" + callbackName );
      } else if ( replaceInData ) {
         s.data = data.replace( rjsonp, "$1" + callbackName );
      } else if ( hasCallback ) {
         s.url += ( rquestion.test( url ) ? "&" : "?" ) + s.jsonp + "=" + callbackName;
      }

      // Use data converter to retrieve json after script execution
      s.converters["script json"] = function() {
         if ( !responseContainer ) {
            jQuery.error( callbackName + " was not called" );
         }
         return responseContainer[ 0 ];
      };

      // force json dataType
      s.dataTypes[ 0 ] = "json";

      // Install callback
      window[ callbackName ] = function() {
         responseContainer = arguments;
      };

      // Clean-up function (fires after converters)
      jqXHR.always(function() {
         // Restore preexisting value
         window[ callbackName ] = overwritten;

         // Save back as free
         if ( s[ callbackName ] ) {
            // make sure that re-using the options doesn't screw things around
            s.jsonpCallback = originalSettings.jsonpCallback;

            // save the callback name for future use
            oldCallbacks.push( callbackName );
         }

         // Call if it was a function and we have a response
         if ( responseContainer && jQuery.isFunction( overwritten ) ) {
            overwritten( responseContainer[ 0 ] );
         }

         responseContainer = overwritten = undefined;
      });

      // Delegate to script
      return "script";
   }
});
// Install script dataType
jQuery.ajaxSetup({
   accepts: {
      script: "text/javascript, application/javascript, application/ecmascript, application/x-ecmascript"
   },
   contents: {
      script: /javascript|ecmascript/
   },
   converters: {
      "text script": function( text ) {
         jQuery.globalEval( text );
         return text;
      }
   }
});

// Handle cache's special case and global
jQuery.ajaxPrefilter( "script", function( s ) {
   if ( s.cache === undefined ) {
      s.cache = false;
   }
   if ( s.crossDomain ) {
      s.type = "GET";
      s.global = false;
   }
});

// Bind script tag hack transport
jQuery.ajaxTransport( "script", function(s) {

   // This transport only deals with cross domain requests
   if ( s.crossDomain ) {

      var script,
         head = document.head || document.getElementsByTagName( "head" )[0] || document.documentElement;

      return {

         send: function( _, callback ) {

            script = document.createElement( "script" );

            script.async = "async";

            if ( s.scriptCharset ) {
               script.charset = s.scriptCharset;
            }

            script.src = s.url;

            // Attach handlers for all browsers
            script.onload = script.onreadystatechange = function( _, isAbort ) {

               if ( isAbort || !script.readyState || /loaded|complete/.test( script.readyState ) ) {

                  // Handle memory leak in IE
                  script.onload = script.onreadystatechange = null;

                  // Remove the script
                  if ( head && script.parentNode ) {
                     head.removeChild( script );
                  }

                  // Dereference the script
                  script = undefined;

                  // Callback if not abort
                  if ( !isAbort ) {
                     callback( 200, "success" );
                  }
               }
            };
            // Use insertBefore instead of appendChild  to circumvent an IE6 bug.
            // This arises when a base node is used (#2709 and #4378).
            head.insertBefore( script, head.firstChild );
         },

         abort: function() {
            if ( script ) {
               script.onload( 0, 1 );
            }
         }
      };
   }
});
var xhrCallbacks,
   // #5280: Internet Explorer will keep connections alive if we don't abort on unload
   xhrOnUnloadAbort = window.ActiveXObject ? function() {
      // Abort all pending requests
      for ( var key in xhrCallbacks ) {
         xhrCallbacks[ key ]( 0, 1 );
      }
   } : false,
   xhrId = 0;

// Functions to create xhrs
function createStandardXHR() {
   try {
      return new window.XMLHttpRequest();
   } catch( e ) {}
}

function createActiveXHR() {
   try {
      return new window.ActiveXObject( "Microsoft.XMLHTTP" );
   } catch( e ) {}
}

// Create the request object
// (This is still attached to ajaxSettings for backward compatibility)
jQuery.ajaxSettings.xhr = window.ActiveXObject ?
   /* Microsoft failed to properly
    * implement the XMLHttpRequest in IE7 (can't request local files),
    * so we use the ActiveXObject when it is available
    * Additionally XMLHttpRequest can be disabled in IE7/IE8 so
    * we need a fallback.
    */
   function() {
      return !this.isLocal && createStandardXHR() || createActiveXHR();
   } :
   // For all other browsers, use the standard XMLHttpRequest object
   createStandardXHR;

// Determine support properties
(function( xhr ) {
   jQuery.extend( jQuery.support, {
      ajax: !!xhr,
      cors: !!xhr && ( "withCredentials" in xhr )
   });
})( jQuery.ajaxSettings.xhr() );

// Create transport if the browser can provide an xhr
if ( jQuery.support.ajax ) {

   jQuery.ajaxTransport(function( s ) {
      // Cross domain only allowed if supported through XMLHttpRequest
      if ( !s.crossDomain || jQuery.support.cors ) {

         var callback;

         return {
            send: function( headers, complete ) {

               // Get a new xhr
               var handle, i,
                  xhr = s.xhr();

               // Open the socket
               // Passing null username, generates a login popup on Opera (#2865)
               if ( s.username ) {
                  xhr.open( s.type, s.url, s.async, s.username, s.password );
               } else {
                  xhr.open( s.type, s.url, s.async );
               }

               // Apply custom fields if provided
               if ( s.xhrFields ) {
                  for ( i in s.xhrFields ) {
                     xhr[ i ] = s.xhrFields[ i ];
                  }
               }

               // Override mime type if needed
               if ( s.mimeType && xhr.overrideMimeType ) {
                  xhr.overrideMimeType( s.mimeType );
               }

               // X-Requested-With header
               // For cross-domain requests, seeing as conditions for a preflight are
               // akin to a jigsaw puzzle, we simply never set it to be sure.
               // (it can always be set on a per-request basis or even using ajaxSetup)
               // For same-domain requests, won't change header if already provided.
               if ( !s.crossDomain && !headers["X-Requested-With"] ) {
                  headers[ "X-Requested-With" ] = "XMLHttpRequest";
               }

               // Need an extra try/catch for cross domain requests in Firefox 3
               try {
                  for ( i in headers ) {
                     xhr.setRequestHeader( i, headers[ i ] );
                  }
               } catch( _ ) {}

               // Do send the request
               // This may raise an exception which is actually
               // handled in jQuery.ajax (so no try/catch here)
               xhr.send( ( s.hasContent && s.data ) || null );

               // Listener
               callback = function( _, isAbort ) {

                  var status,
                     statusText,
                     responseHeaders,
                     responses,
                     xml;

                  // Firefox throws exceptions when accessing properties
                  // of an xhr when a network error occurred
                  // http://helpful.knobs-dials.com/index.php/Component_returned_failure_code:_0x80040111_(NS_ERROR_NOT_AVAILABLE)
                  try {

                     // Was never called and is aborted or complete
                     if ( callback && ( isAbort || xhr.readyState === 4 ) ) {

                        // Only called once
                        callback = undefined;

                        // Do not keep as active anymore
                        if ( handle ) {
                           xhr.onreadystatechange = jQuery.noop;
                           if ( xhrOnUnloadAbort ) {
                              delete xhrCallbacks[ handle ];
                           }
                        }

                        // If it's an abort
                        if ( isAbort ) {
                           // Abort it manually if needed
                           if ( xhr.readyState !== 4 ) {
                              xhr.abort();
                           }
                        } else {
                           status = xhr.status;
                           responseHeaders = xhr.getAllResponseHeaders();
                           responses = {};
                           xml = xhr.responseXML;

                           // Construct response list
                           if ( xml && xml.documentElement /* #4958 */ ) {
                              responses.xml = xml;
                           }

                           // When requesting binary data, IE6-9 will throw an exception
                           // on any attempt to access responseText (#11426)
                           try {
                              responses.text = xhr.responseText;
                           } catch( _ ) {
                           }

                           // Firefox throws an exception when accessing
                           // statusText for faulty cross-domain requests
                           try {
                              statusText = xhr.statusText;
                           } catch( e ) {
                              // We normalize with Webkit giving an empty statusText
                              statusText = "";
                           }

                           // Filter status for non standard behaviors

                           // If the request is local and we have data: assume a success
                           // (success with no data won't get notified, that's the best we
                           // can do given current implementations)
                           if ( !status && s.isLocal && !s.crossDomain ) {
                              status = responses.text ? 200 : 404;
                           // IE - #1450: sometimes returns 1223 when it should be 204
                           } else if ( status === 1223 ) {
                              status = 204;
                           }
                        }
                     }
                  } catch( firefoxAccessException ) {
                     if ( !isAbort ) {
                        complete( -1, firefoxAccessException );
                     }
                  }

                  // Call complete if needed
                  if ( responses ) {
                     complete( status, statusText, responses, responseHeaders );
                  }
               };

               if ( !s.async ) {
                  // if we're in sync mode we fire the callback
                  callback();
               } else if ( xhr.readyState === 4 ) {
                  // (IE6 & IE7) if it's in cache and has been
                  // retrieved directly we need to fire the callback
                  setTimeout( callback, 0 );
               } else {
                  handle = ++xhrId;
                  if ( xhrOnUnloadAbort ) {
                     // Create the active xhrs callbacks list if needed
                     // and attach the unload handler
                     if ( !xhrCallbacks ) {
                        xhrCallbacks = {};
                        jQuery( window ).unload( xhrOnUnloadAbort );
                     }
                     // Add to list of active xhrs callbacks
                     xhrCallbacks[ handle ] = callback;
                  }
                  xhr.onreadystatechange = callback;
               }
            },

            abort: function() {
               if ( callback ) {
                  callback(0,1);
               }
            }
         };
      }
   });
}
var fxNow, timerId,
   rfxtypes = /^(?:toggle|show|hide)$/,
   rfxnum = new RegExp( "^(?:([-+])=|)(" + core_pnum + ")([a-z%]*)$", "i" ),
   rrun = /queueHooks$/,
   animationPrefilters = [ defaultPrefilter ],
   tweeners = {
      "*": [function( prop, value ) {
         var end, unit,
            tween = this.createTween( prop, value ),
            parts = rfxnum.exec( value ),
            target = tween.cur(),
            start = +target || 0,
            scale = 1,
            maxIterations = 20;

         if ( parts ) {
            end = +parts[2];
            unit = parts[3] || ( jQuery.cssNumber[ prop ] ? "" : "px" );

            // We need to compute starting value
            if ( unit !== "px" && start ) {
               // Iteratively approximate from a nonzero starting point
               // Prefer the current property, because this process will be trivial if it uses the same units
               // Fallback to end or a simple constant
               start = jQuery.css( tween.elem, prop, true ) || end || 1;

               do {
                  // If previous iteration zeroed out, double until we get *something*
                  // Use a string for doubling factor so we don't accidentally see scale as unchanged below
                  scale = scale || ".5";

                  // Adjust and apply
                  start = start / scale;
                  jQuery.style( tween.elem, prop, start + unit );

               // Update scale, tolerating zero or NaN from tween.cur()
               // And breaking the loop if scale is unchanged or perfect, or if we've just had enough
               } while ( scale !== (scale = tween.cur() / target) && scale !== 1 && --maxIterations );
            }

            tween.unit = unit;
            tween.start = start;
            // If a +=/-= token was provided, we're doing a relative animation
            tween.end = parts[1] ? start + ( parts[1] + 1 ) * end : end;
         }
         return tween;
      }]
   };

// Animations created synchronously will run synchronously
function createFxNow() {
   setTimeout(function() {
      fxNow = undefined;
   }, 0 );
   return ( fxNow = jQuery.now() );
}

function createTweens( animation, props ) {
   jQuery.each( props, function( prop, value ) {
      var collection = ( tweeners[ prop ] || [] ).concat( tweeners[ "*" ] ),
         index = 0,
         length = collection.length;
      for ( ; index < length; index++ ) {
         if ( collection[ index ].call( animation, prop, value ) ) {

            // we're done with this property
            return;
         }
      }
   });
}

function Animation( elem, properties, options ) {
   var result,
      index = 0,
      tweenerIndex = 0,
      length = animationPrefilters.length,
      deferred = jQuery.Deferred().always( function() {
         // don't match elem in the :animated selector
         delete tick.elem;
      }),
      tick = function() {
         var currentTime = fxNow || createFxNow(),
            remaining = Math.max( 0, animation.startTime + animation.duration - currentTime ),
            percent = 1 - ( remaining / animation.duration || 0 ),
            index = 0,
            length = animation.tweens.length;

         for ( ; index < length ; index++ ) {
            animation.tweens[ index ].run( percent );
         }

         deferred.notifyWith( elem, [ animation, percent, remaining ]);

         if ( percent < 1 && length ) {
            return remaining;
         } else {
            deferred.resolveWith( elem, [ animation ] );
            return false;
         }
      },
      animation = deferred.promise({
         elem: elem,
         props: jQuery.extend( {}, properties ),
         opts: jQuery.extend( true, { specialEasing: {} }, options ),
         originalProperties: properties,
         originalOptions: options,
         startTime: fxNow || createFxNow(),
         duration: options.duration,
         tweens: [],
         createTween: function( prop, end, easing ) {
            var tween = jQuery.Tween( elem, animation.opts, prop, end,
                  animation.opts.specialEasing[ prop ] || animation.opts.easing );
            animation.tweens.push( tween );
            return tween;
         },
         stop: function( gotoEnd ) {
            var index = 0,
               // if we are going to the end, we want to run all the tweens
               // otherwise we skip this part
               length = gotoEnd ? animation.tweens.length : 0;

            for ( ; index < length ; index++ ) {
               animation.tweens[ index ].run( 1 );
            }

            // resolve when we played the last frame
            // otherwise, reject
            if ( gotoEnd ) {
               deferred.resolveWith( elem, [ animation, gotoEnd ] );
            } else {
               deferred.rejectWith( elem, [ animation, gotoEnd ] );
            }
            return this;
         }
      }),
      props = animation.props;

   propFilter( props, animation.opts.specialEasing );

   for ( ; index < length ; index++ ) {
      result = animationPrefilters[ index ].call( animation, elem, props, animation.opts );
      if ( result ) {
         return result;
      }
   }

   createTweens( animation, props );

   if ( jQuery.isFunction( animation.opts.start ) ) {
      animation.opts.start.call( elem, animation );
   }

   jQuery.fx.timer(
      jQuery.extend( tick, {
         anim: animation,
         queue: animation.opts.queue,
         elem: elem
      })
   );

   // attach callbacks from options
   return animation.progress( animation.opts.progress )
      .done( animation.opts.done, animation.opts.complete )
      .fail( animation.opts.fail )
      .always( animation.opts.always );
}

function propFilter( props, specialEasing ) {
   var index, name, easing, value, hooks;

   // camelCase, specialEasing and expand cssHook pass
   for ( index in props ) {
      name = jQuery.camelCase( index );
      easing = specialEasing[ name ];
      value = props[ index ];
      if ( jQuery.isArray( value ) ) {
         easing = value[ 1 ];
         value = props[ index ] = value[ 0 ];
      }

      if ( index !== name ) {
         props[ name ] = value;
         delete props[ index ];
      }

      hooks = jQuery.cssHooks[ name ];
      if ( hooks && "expand" in hooks ) {
         value = hooks.expand( value );
         delete props[ name ];

         // not quite $.extend, this wont overwrite keys already present.
         // also - reusing 'index' from above because we have the correct "name"
         for ( index in value ) {
            if ( !( index in props ) ) {
               props[ index ] = value[ index ];
               specialEasing[ index ] = easing;
            }
         }
      } else {
         specialEasing[ name ] = easing;
      }
   }
}

jQuery.Animation = jQuery.extend( Animation, {

   tweener: function( props, callback ) {
      if ( jQuery.isFunction( props ) ) {
         callback = props;
         props = [ "*" ];
      } else {
         props = props.split(" ");
      }

      var prop,
         index = 0,
         length = props.length;

      for ( ; index < length ; index++ ) {
         prop = props[ index ];
         tweeners[ prop ] = tweeners[ prop ] || [];
         tweeners[ prop ].unshift( callback );
      }
   },

   prefilter: function( callback, prepend ) {
      if ( prepend ) {
         animationPrefilters.unshift( callback );
      } else {
         animationPrefilters.push( callback );
      }
   }
});

function defaultPrefilter( elem, props, opts ) {
   var index, prop, value, length, dataShow, tween, hooks, oldfire,
      anim = this,
      style = elem.style,
      orig = {},
      handled = [],
      hidden = elem.nodeType && isHidden( elem );

   // handle queue: false promises
   if ( !opts.queue ) {
      hooks = jQuery._queueHooks( elem, "fx" );
      if ( hooks.unqueued == null ) {
         hooks.unqueued = 0;
         oldfire = hooks.empty.fire;
         hooks.empty.fire = function() {
            if ( !hooks.unqueued ) {
               oldfire();
            }
         };
      }
      hooks.unqueued++;

      anim.always(function() {
         // doing this makes sure that the complete handler will be called
         // before this completes
         anim.always(function() {
            hooks.unqueued--;
            if ( !jQuery.queue( elem, "fx" ).length ) {
               hooks.empty.fire();
            }
         });
      });
   }

   // height/width overflow pass
   if ( elem.nodeType === 1 && ( "height" in props || "width" in props ) ) {
      // Make sure that nothing sneaks out
      // Record all 3 overflow attributes because IE does not
      // change the overflow attribute when overflowX and
      // overflowY are set to the same value
      opts.overflow = [ style.overflow, style.overflowX, style.overflowY ];

      // Set display property to inline-block for height/width
      // animations on inline elements that are having width/height animated
      if ( jQuery.css( elem, "display" ) === "inline" &&
            jQuery.css( elem, "float" ) === "none" ) {

         // inline-level elements accept inline-block;
         // block-level elements need to be inline with layout
         if ( !jQuery.support.inlineBlockNeedsLayout || css_defaultDisplay( elem.nodeName ) === "inline" ) {
            style.display = "inline-block";

         } else {
            style.zoom = 1;
         }
      }
   }

   if ( opts.overflow ) {
      style.overflow = "hidden";
      if ( !jQuery.support.shrinkWrapBlocks ) {
         anim.done(function() {
            style.overflow = opts.overflow[ 0 ];
            style.overflowX = opts.overflow[ 1 ];
            style.overflowY = opts.overflow[ 2 ];
         });
      }
   }


   // show/hide pass
   for ( index in props ) {
      value = props[ index ];
      if ( rfxtypes.exec( value ) ) {
         delete props[ index ];
         if ( value === ( hidden ? "hide" : "show" ) ) {
            continue;
         }
         handled.push( index );
      }
   }

   length = handled.length;
   if ( length ) {
      dataShow = jQuery._data( elem, "fxshow" ) || jQuery._data( elem, "fxshow", {} );
      if ( hidden ) {
         jQuery( elem ).show();
      } else {
         anim.done(function() {
            jQuery( elem ).hide();
         });
      }
      anim.done(function() {
         var prop;
         jQuery.removeData( elem, "fxshow", true );
         for ( prop in orig ) {
            jQuery.style( elem, prop, orig[ prop ] );
         }
      });
      for ( index = 0 ; index < length ; index++ ) {
         prop = handled[ index ];
         tween = anim.createTween( prop, hidden ? dataShow[ prop ] : 0 );
         orig[ prop ] = dataShow[ prop ] || jQuery.style( elem, prop );

         if ( !( prop in dataShow ) ) {
            dataShow[ prop ] = tween.start;
            if ( hidden ) {
               tween.end = tween.start;
               tween.start = prop === "width" || prop === "height" ? 1 : 0;
            }
         }
      }
   }
}

function Tween( elem, options, prop, end, easing ) {
   return new Tween.prototype.init( elem, options, prop, end, easing );
}
jQuery.Tween = Tween;

Tween.prototype = {
   constructor: Tween,
   init: function( elem, options, prop, end, easing, unit ) {
      this.elem = elem;
      this.prop = prop;
      this.easing = easing || "swing";
      this.options = options;
      this.start = this.now = this.cur();
      this.end = end;
      this.unit = unit || ( jQuery.cssNumber[ prop ] ? "" : "px" );
   },
   cur: function() {
      var hooks = Tween.propHooks[ this.prop ];

      return hooks && hooks.get ?
         hooks.get( this ) :
         Tween.propHooks._default.get( this );
   },
   run: function( percent ) {
      var eased,
         hooks = Tween.propHooks[ this.prop ];

      if ( this.options.duration ) {
         this.pos = eased = jQuery.easing[ this.easing ](
            percent, this.options.duration * percent, 0, 1, this.options.duration
         );
      } else {
         this.pos = eased = percent;
      }
      this.now = ( this.end - this.start ) * eased + this.start;

      if ( this.options.step ) {
         this.options.step.call( this.elem, this.now, this );
      }

      if ( hooks && hooks.set ) {
         hooks.set( this );
      } else {
         Tween.propHooks._default.set( this );
      }
      return this;
   }
};

Tween.prototype.init.prototype = Tween.prototype;

Tween.propHooks = {
   _default: {
      get: function( tween ) {
         var result;

         if ( tween.elem[ tween.prop ] != null &&
            (!tween.elem.style || tween.elem.style[ tween.prop ] == null) ) {
            return tween.elem[ tween.prop ];
         }

         // passing any value as a 4th parameter to .css will automatically
         // attempt a parseFloat and fallback to a string if the parse fails
         // so, simple values such as "10px" are parsed to Float.
         // complex values such as "rotate(1rad)" are returned as is.
         result = jQuery.css( tween.elem, tween.prop, false, "" );
         // Empty strings, null, undefined and "auto" are converted to 0.
         return !result || result === "auto" ? 0 : result;
      },
      set: function( tween ) {
         // use step hook for back compat - use cssHook if its there - use .style if its
         // available and use plain properties where available
         if ( jQuery.fx.step[ tween.prop ] ) {
            jQuery.fx.step[ tween.prop ]( tween );
         } else if ( tween.elem.style && ( tween.elem.style[ jQuery.cssProps[ tween.prop ] ] != null || jQuery.cssHooks[ tween.prop ] ) ) {
            jQuery.style( tween.elem, tween.prop, tween.now + tween.unit );
         } else {
            tween.elem[ tween.prop ] = tween.now;
         }
      }
   }
};

// Remove in 2.0 - this supports IE8's panic based approach
// to setting things on disconnected nodes

Tween.propHooks.scrollTop = Tween.propHooks.scrollLeft = {
   set: function( tween ) {
      if ( tween.elem.nodeType && tween.elem.parentNode ) {
         tween.elem[ tween.prop ] = tween.now;
      }
   }
};

jQuery.each([ "toggle", "show", "hide" ], function( i, name ) {
   var cssFn = jQuery.fn[ name ];
   jQuery.fn[ name ] = function( speed, easing, callback ) {
      return speed == null || typeof speed === "boolean" ||
         // special check for .toggle( handler, handler, ... )
         ( !i && jQuery.isFunction( speed ) && jQuery.isFunction( easing ) ) ?
         cssFn.apply( this, arguments ) :
         this.animate( genFx( name, true ), speed, easing, callback );
   };
});

jQuery.fn.extend({
   fadeTo: function( speed, to, easing, callback ) {

      // show any hidden elements after setting opacity to 0
      return this.filter( isHidden ).css( "opacity", 0 ).show()

         // animate to the value specified
         .end().animate({ opacity: to }, speed, easing, callback );
   },
   animate: function( prop, speed, easing, callback ) {
      var empty = jQuery.isEmptyObject( prop ),
         optall = jQuery.speed( speed, easing, callback ),
         doAnimation = function() {
            // Operate on a copy of prop so per-property easing won't be lost
            var anim = Animation( this, jQuery.extend( {}, prop ), optall );

            // Empty animations resolve immediately
            if ( empty ) {
               anim.stop( true );
            }
         };

      return empty || optall.queue === false ?
         this.each( doAnimation ) :
         this.queue( optall.queue, doAnimation );
   },
   stop: function( type, clearQueue, gotoEnd ) {
      var stopQueue = function( hooks ) {
         var stop = hooks.stop;
         delete hooks.stop;
         stop( gotoEnd );
      };

      if ( typeof type !== "string" ) {
         gotoEnd = clearQueue;
         clearQueue = type;
         type = undefined;
      }
      if ( clearQueue && type !== false ) {
         this.queue( type || "fx", [] );
      }

      return this.each(function() {
         var dequeue = true,
            index = type != null && type + "queueHooks",
            timers = jQuery.timers,
            data = jQuery._data( this );

         if ( index ) {
            if ( data[ index ] && data[ index ].stop ) {
               stopQueue( data[ index ] );
            }
         } else {
            for ( index in data ) {
               if ( data[ index ] && data[ index ].stop && rrun.test( index ) ) {
                  stopQueue( data[ index ] );
               }
            }
         }

         for ( index = timers.length; index--; ) {
            if ( timers[ index ].elem === this && (type == null || timers[ index ].queue === type) ) {
               timers[ index ].anim.stop( gotoEnd );
               dequeue = false;
               timers.splice( index, 1 );
            }
         }

         // start the next in the queue if the last step wasn't forced
         // timers currently will call their complete callbacks, which will dequeue
         // but only if they were gotoEnd
         if ( dequeue || !gotoEnd ) {
            jQuery.dequeue( this, type );
         }
      });
   }
});

// Generate parameters to create a standard animation
function genFx( type, includeWidth ) {
   var which,
      attrs = { height: type },
      i = 0;

   // if we include width, step value is 1 to do all cssExpand values,
   // if we don't include width, step value is 2 to skip over Left and Right
   includeWidth = includeWidth? 1 : 0;
   for( ; i < 4 ; i += 2 - includeWidth ) {
      which = cssExpand[ i ];
      attrs[ "margin" + which ] = attrs[ "padding" + which ] = type;
   }

   if ( includeWidth ) {
      attrs.opacity = attrs.width = type;
   }

   return attrs;
}

// Generate shortcuts for custom animations
jQuery.each({
   slideDown: genFx("show"),
   slideUp: genFx("hide"),
   slideToggle: genFx("toggle"),
   fadeIn: { opacity: "show" },
   fadeOut: { opacity: "hide" },
   fadeToggle: { opacity: "toggle" }
}, function( name, props ) {
   jQuery.fn[ name ] = function( speed, easing, callback ) {
      return this.animate( props, speed, easing, callback );
   };
});

jQuery.speed = function( speed, easing, fn ) {
   var opt = speed && typeof speed === "object" ? jQuery.extend( {}, speed ) : {
      complete: fn || !fn && easing ||
         jQuery.isFunction( speed ) && speed,
      duration: speed,
      easing: fn && easing || easing && !jQuery.isFunction( easing ) && easing
   };

   opt.duration = jQuery.fx.off ? 0 : typeof opt.duration === "number" ? opt.duration :
      opt.duration in jQuery.fx.speeds ? jQuery.fx.speeds[ opt.duration ] : jQuery.fx.speeds._default;

   // normalize opt.queue - true/undefined/null -> "fx"
   if ( opt.queue == null || opt.queue === true ) {
      opt.queue = "fx";
   }

   // Queueing
   opt.old = opt.complete;

   opt.complete = function() {
      if ( jQuery.isFunction( opt.old ) ) {
         opt.old.call( this );
      }

      if ( opt.queue ) {
         jQuery.dequeue( this, opt.queue );
      }
   };

   return opt;
};

jQuery.easing = {
   linear: function( p ) {
      return p;
   },
   swing: function( p ) {
      return 0.5 - Math.cos( p*Math.PI ) / 2;
   }
};

jQuery.timers = [];
jQuery.fx = Tween.prototype.init;
jQuery.fx.tick = function() {
   var timer,
      timers = jQuery.timers,
      i = 0;

   for ( ; i < timers.length; i++ ) {
      timer = timers[ i ];
      // Checks the timer has not already been removed
      if ( !timer() && timers[ i ] === timer ) {
         timers.splice( i--, 1 );
      }
   }

   if ( !timers.length ) {
      jQuery.fx.stop();
   }
};

jQuery.fx.timer = function( timer ) {
   if ( timer() && jQuery.timers.push( timer ) && !timerId ) {
      timerId = setInterval( jQuery.fx.tick, jQuery.fx.interval );
   }
};

jQuery.fx.interval = 13;

jQuery.fx.stop = function() {
   clearInterval( timerId );
   timerId = null;
};

jQuery.fx.speeds = {
   slow: 600,
   fast: 200,
   // Default speed
   _default: 400
};

// Back Compat <1.8 extension point
jQuery.fx.step = {};

if ( jQuery.expr && jQuery.expr.filters ) {
   jQuery.expr.filters.animated = function( elem ) {
      return jQuery.grep(jQuery.timers, function( fn ) {
         return elem === fn.elem;
      }).length;
   };
}
var rroot = /^(?:body|html)$/i;

jQuery.fn.offset = function( options ) {
   if ( arguments.length ) {
      return options === undefined ?
         this :
         this.each(function( i ) {
            jQuery.offset.setOffset( this, options, i );
         });
   }

   var docElem, body, win, clientTop, clientLeft, scrollTop, scrollLeft,
      box = { top: 0, left: 0 },
      elem = this[ 0 ],
      doc = elem && elem.ownerDocument;

   if ( !doc ) {
      return;
   }

   if ( (body = doc.body) === elem ) {
      return jQuery.offset.bodyOffset( elem );
   }

   docElem = doc.documentElement;

   // Make sure it's not a disconnected DOM node
   if ( !jQuery.contains( docElem, elem ) ) {
      return box;
   }

   // If we don't have gBCR, just use 0,0 rather than error
   // BlackBerry 5, iOS 3 (original iPhone)
   if ( typeof elem.getBoundingClientRect !== "undefined" ) {
      box = elem.getBoundingClientRect();
   }
   win = getWindow( doc );
   clientTop  = docElem.clientTop  || body.clientTop  || 0;
   clientLeft = docElem.clientLeft || body.clientLeft || 0;
   scrollTop  = win.pageYOffset || docElem.scrollTop;
   scrollLeft = win.pageXOffset || docElem.scrollLeft;
   return {
      top: box.top  + scrollTop  - clientTop,
      left: box.left + scrollLeft - clientLeft
   };
};

jQuery.offset = {

   bodyOffset: function( body ) {
      var top = body.offsetTop,
         left = body.offsetLeft;

      if ( jQuery.support.doesNotIncludeMarginInBodyOffset ) {
         top  += parseFloat( jQuery.css(body, "marginTop") ) || 0;
         left += parseFloat( jQuery.css(body, "marginLeft") ) || 0;
      }

      return { top: top, left: left };
   },

   setOffset: function( elem, options, i ) {
      var position = jQuery.css( elem, "position" );

      // set position first, in-case top/left are set even on static elem
      if ( position === "static" ) {
         elem.style.position = "relative";
      }

      var curElem = jQuery( elem ),
         curOffset = curElem.offset(),
         curCSSTop = jQuery.css( elem, "top" ),
         curCSSLeft = jQuery.css( elem, "left" ),
         calculatePosition = ( position === "absolute" || position === "fixed" ) && jQuery.inArray("auto", [curCSSTop, curCSSLeft]) > -1,
         props = {}, curPosition = {}, curTop, curLeft;

      // need to be able to calculate position if either top or left is auto and position is either absolute or fixed
      if ( calculatePosition ) {
         curPosition = curElem.position();
         curTop = curPosition.top;
         curLeft = curPosition.left;
      } else {
         curTop = parseFloat( curCSSTop ) || 0;
         curLeft = parseFloat( curCSSLeft ) || 0;
      }

      if ( jQuery.isFunction( options ) ) {
         options = options.call( elem, i, curOffset );
      }

      if ( options.top != null ) {
         props.top = ( options.top - curOffset.top ) + curTop;
      }
      if ( options.left != null ) {
         props.left = ( options.left - curOffset.left ) + curLeft;
      }

      if ( "using" in options ) {
         options.using.call( elem, props );
      } else {
         curElem.css( props );
      }
   }
};


jQuery.fn.extend({

   position: function() {
      if ( !this[0] ) {
         return;
      }

      var elem = this[0],

      // Get *real* offsetParent
      offsetParent = this.offsetParent(),

      // Get correct offsets
      offset       = this.offset(),
      parentOffset = rroot.test(offsetParent[0].nodeName) ? { top: 0, left: 0 } : offsetParent.offset();

      // Subtract element margins
      // note: when an element has margin: auto the offsetLeft and marginLeft
      // are the same in Safari causing offset.left to incorrectly be 0
      offset.top  -= parseFloat( jQuery.css(elem, "marginTop") ) || 0;
      offset.left -= parseFloat( jQuery.css(elem, "marginLeft") ) || 0;

      // Add offsetParent borders
      parentOffset.top  += parseFloat( jQuery.css(offsetParent[0], "borderTopWidth") ) || 0;
      parentOffset.left += parseFloat( jQuery.css(offsetParent[0], "borderLeftWidth") ) || 0;

      // Subtract the two offsets
      return {
         top:  offset.top  - parentOffset.top,
         left: offset.left - parentOffset.left
      };
   },

   offsetParent: function() {
      return this.map(function() {
         var offsetParent = this.offsetParent || document.body;
         while ( offsetParent && (!rroot.test(offsetParent.nodeName) && jQuery.css(offsetParent, "position") === "static") ) {
            offsetParent = offsetParent.offsetParent;
         }
         return offsetParent || document.body;
      });
   }
});


// Create scrollLeft and scrollTop methods
jQuery.each( {scrollLeft: "pageXOffset", scrollTop: "pageYOffset"}, function( method, prop ) {
   var top = /Y/.test( prop );

   jQuery.fn[ method ] = function( val ) {
      return jQuery.access( this, function( elem, method, val ) {
         var win = getWindow( elem );

         if ( val === undefined ) {
            return win ? (prop in win) ? win[ prop ] :
               win.document.documentElement[ method ] :
               elem[ method ];
         }

         if ( win ) {
            win.scrollTo(
               !top ? val : jQuery( win ).scrollLeft(),
                top ? val : jQuery( win ).scrollTop()
            );

         } else {
            elem[ method ] = val;
         }
      }, method, val, arguments.length, null );
   };
});

function getWindow( elem ) {
   return jQuery.isWindow( elem ) ?
      elem :
      elem.nodeType === 9 ?
         elem.defaultView || elem.parentWindow :
         false;
}
// Create innerHeight, innerWidth, height, width, outerHeight and outerWidth methods
jQuery.each( { Height: "height", Width: "width" }, function( name, type ) {
   jQuery.each( { padding: "inner" + name, content: type, "": "outer" + name }, function( defaultExtra, funcName ) {
      // margin is only for outerHeight, outerWidth
      jQuery.fn[ funcName ] = function( margin, value ) {
         var chainable = arguments.length && ( defaultExtra || typeof margin !== "boolean" ),
            extra = defaultExtra || ( margin === true || value === true ? "margin" : "border" );

         return jQuery.access( this, function( elem, type, value ) {
            var doc;

            if ( jQuery.isWindow( elem ) ) {
               // As of 5/8/2012 this will yield incorrect results for Mobile Safari, but there
               // isn't a whole lot we can do. See pull request at this URL for discussion:
               // https://github.com/jquery/jquery/pull/764
               return elem.document.documentElement[ "client" + name ];
            }

            // Get document width or height
            if ( elem.nodeType === 9 ) {
               doc = elem.documentElement;

               // Either scroll[Width/Height] or offset[Width/Height] or client[Width/Height], whichever is greatest
               // unfortunately, this causes bug #3838 in IE6/8 only, but there is currently no good, small way to fix it.
               return Math.max(
                  elem.body[ "scroll" + name ], doc[ "scroll" + name ],
                  elem.body[ "offset" + name ], doc[ "offset" + name ],
                  doc[ "client" + name ]
               );
            }

            return value === undefined ?
               // Get width or height on the element, requesting but not forcing parseFloat
               jQuery.css( elem, type, value, extra ) :

               // Set width or height on the element
               jQuery.style( elem, type, value, extra );
         }, type, chainable ? margin : undefined, chainable, null );
      };
   });
});
// Expose jQuery to the global object
window.jQuery = window.$ = jQuery;

// Expose jQuery as an AMD module, but only for AMD loaders that
// understand the issues with loading multiple versions of jQuery
// in a page that all might call define(). The loader will indicate
// they have special allowances for multiple jQuery versions by
// specifying define.amd.jQuery = true. Register as a named module,
// since jQuery can be concatenated with other files that may use define,
// but not use a proper concatenation script that understands anonymous
// AMD modules. A named AMD is safest and most robust way to register.
// Lowercase jquery is used because AMD module names are derived from
// file names, and jQuery is normally delivered in a lowercase file name.
// Do this after creating the global so that if an AMD module wants to call
// noConflict to hide this version of jQuery, it will work.
if ( typeof define === "function" && define.amd && define.amd.jQuery ) {
   define( "jquery", [], function () { return jQuery; } );
}

})( window );
/*! 
 * a-tools 1.5.2
 * 
 * Copyright (c) 2009 Andrey Kramarev(andrey.kramarev[at]ampparit.com), Ampparit Inc. (www.ampparit.com)
 * Licensed under the MIT license.
 * http://www.ampparit.fi/a-tools/license.txt
 *
 * Basic usage:
 
	<textarea></textarea>
	<input type="text" />

	// Get current selection
	var sel = $("textarea").getSelection()
	
	// Replace current selection
	$("input").replaceSelection("foo");

	// Count characters
	alert($("textarea").countCharacters());

	// Set max length without callback function
	$("textarea").setMaxLength(7);

	// Set max length with callback function which will be called when limit is exceeded
	$("textarea").setMaxLength(10, function() {
		alert("hello")
	});

	// Removing limit:
	$("textarea").setMaxLength(-1);
	
	// Insert text at current caret position
	$("#textarea").insertAtCaretPos("hello");
	
	// Set caret position (1 = beginning, -1 = end)
	$("#textArea").setCaretPos(10);
	
	// Set Selection
	$("#textArea").setSelection(10,15);

 */

// Modified by Logue

var caretPositionAmp = new Array();
$(document).ready(function(){
	if(navigator.appName == "Microsoft Internet Explorer") {
		obj = document.getElementsByTagName('TEXTAREA');
		var input;
		var i = 0;
		for (var i = 0; i < obj.length; i++) {
			input = obj[i];
			caretPositionAmp[i] = input.value.length;
			input.onmouseup = function() { // for IE because it loses caret position when focus changed
				input = document.activeElement;
				for (var i = 0; i < obj.length; i++) {
					if (obj[i] == input) {
						break;
					}
				}
				input.focus();
				var s = document.selection.createRange();
				var re = input.createTextRange();
				var rc = re.duplicate();
				re.moveToBookmark(s.getBookmark());
				rc.setEndPoint("EndToStart", re);
				caretPositionAmp[i] = rc.text.length;
			}
			input.onkeyup = function() {
				input = document.activeElement;
				for (var i = 0; i < obj.length; i++) {
					if (obj[i] == input) {
						break;
					}
				}
				input.focus();
				var s = document.selection.createRange();
				var re = input.createTextRange();
				var rc = re.duplicate();
				re.moveToBookmark(s.getBookmark());
				rc.setEndPoint("EndToStart", re);
				caretPositionAmp[i] = rc.text.length;
			}
		}
	}
});

jQuery.fn.extend({
	getSelection: function() {  // function for getting selection, and position of the selected text
		var input = this.jquery ? this[0] : this;
		var start;
		var end;
		var part;
		var number = 0;
		input.onmousedown = function() { // for IE 
			if (document.selection && typeof(input.selectionStart) != "number") {
				document.selection.empty();
			} else {
				window.getSelection().removeAllRanges();
			}
		}
		if (document.selection) {
			// part for IE and Opera
			var s = document.selection.createRange();
			var minus = 0;
			var position = 0;
			var minusEnd = 0;
			var re;
			var rc;
			var obj = document.getElementsByTagName('TEXTAREA');
			for (var pos = 0; pos < obj.length; pos++) {
				if (obj[pos] == input) {
					break;
				}
			}
			if (input.value.match(/\n/g) != null) {
					number = input.value.match(/\n/g).length;// number of EOL simbols
			}
			if (s.text) {
				part = s.text;
				// OPERA support
				if (typeof(input.selectionStart) == "number") {
					start = input.selectionStart;
					end = input.selectionEnd;
					// return null if the selected text not from the needed area
					if (start == end) {
						return { start: start, end: end, text: s.text, length: end - start };
					}
				} else {
					// IE support
					re = input.createTextRange();
					rc = re.duplicate();
					firstRe = re.text;
					re.moveToBookmark(s.getBookmark());
					secondRe = re.text;
					rc.setEndPoint("EndToStart", re);
					// return null if the selectyed text not from the needed area
					if (firstRe == secondRe && firstRe != s.text || rc.text.length > firstRe.length) {
						return { start: caretPositionAmp[pos], end: caretPositionAmp[pos], text: "", length: 0 };
					}
					start = rc.text.length; 
					end = rc.text.length + s.text.length;
				}
				// remove all EOL to have the same start and end positons as in MOZILLA
				if (number > 0) {
					for (var i = 0; i <= number; i++) {
						var w = input.value.indexOf("\n", position);
						if (w != -1 && w < start) {
							position = w + 1;
							minus++;
							minusEnd = minus;
						} else if (w != -1 && w >= start && w <= end) {
							if (w == start + 1) {
								minus--;
								minusEnd--;
								position = w + 1;
								continue;
							}
							position = w + 1;
							minusEnd++;
						} else {
							i = number;
						}
					}
				}
				if (s.text.indexOf("\n", 0) == 1) {
					minusEnd = minusEnd + 2;
				}
				start = start - minus;
				end = end - minusEnd;
				
				return { start: start, end: end, text: s.text, length: end - start };
			}
			input.focus ();
			if (typeof(input.selectionStart) == "number") {
				start = input.selectionStart;
			} else {
				s = document.selection.createRange();
				re = input.createTextRange();
				rc = re.duplicate();
				re.moveToBookmark(s.getBookmark());
				rc.setEndPoint("EndToStart", re);
				start = rc.text.length;
			}
			if (number > 0) {
				for (var i = 0; i <= number; i++) {
					var w = input.value.indexOf("\n", position);
					if (w != -1 && w < start) {
						position = w + 1;
						minus++;
					} else {
						i = number;
					}
				}
			}
			start = start - minus;
			if (start == 0 && typeof(input.selectionStart) != "number") {
				start = caretPositionAmp[pos];
				end = caretPositionAmp[pos];
			}
			return { start: start, end: start, text: s.text, length: 0 };
		} else if (typeof(input.selectionStart) == "number" ) {
			start = input.selectionStart;
			end = input.selectionEnd;
			part = input.value.substring(input.selectionStart, input.selectionEnd);
			return { start: start, end: end, text: part, length: end - start };
		} else { return { start: undefined, end: undefined, text: undefined, length: undefined }; }
	},

	// function for the replacement of the selected text
	replaceSelection: function(inputStr) {
		var input = this.jquery ? this[0] : this; 
		//part for IE and Opera
		var start;
		var end;
		var position = 0;
		var rc;
		var re;
		var number = 0;
		var minus = 0;
		var mozScrollFix = ( input.scrollTop == undefined ) ? 0 : input.scrollTop;
		var obj = document.getElementsByTagName('TEXTAREA');
		
		for (var pos = 0; pos < obj.length; pos++) {
			if (obj[pos] == input) {
				break;
			}
		}
		if (document.selection && typeof(input.selectionStart) != "number") {
			var s = document.selection.createRange();
			
			// IE support
			if (typeof(input.selectionStart) != "number") { // return null if the selected text not from the needed area
				var firstRe;
				var secondRe;
				re = input.createTextRange();
				rc = re.duplicate();
				firstRe = re.text;
				re.moveToBookmark(s.getBookmark());
				secondRe = re.text;
				try {
					rc.setEndPoint("EndToStart", re);
				}
				catch(err) {
					return this;
				}
				if (firstRe == secondRe && firstRe != s.text || rc.text.length > firstRe.length) {
					return this;
				}
			}
			if (s.text) {
				part = s.text;
				if (input.value.match(/\n/g) != null) {
					number = input.value.match(/\n/g).length;// number of EOL simbols
				}
				// IE support
				start = rc.text.length; 
				// remove all EOL to have the same start and end positons as in MOZILLA
				if (number > 0) {
					for (var i = 0; i <= number; i++) {
						var w = input.value.indexOf("\n", position);
						if (w != -1 && w < start) {
							position = w + 1;
							minus++;
							
						} else {
							i = number;
						}
					}
				}
				s.text = inputStr;
				caretPositionAmp[pos] = rc.text.length + inputStr.length;
				re.move("character", caretPositionAmp[pos]);
				document.selection.empty();
				input.blur();
			}
			return this;
		} else if (typeof(input.selectionStart) == "number" && // MOZILLA support
				input.selectionStart != input.selectionEnd) {
			
			start = input.selectionStart;
			end = input.selectionEnd;
			input.value = input.value.substr(0, start) + inputStr + input.value.substr(end);
			position = start + inputStr.length;
			input.setSelectionRange(position, position); 
			input.scrollTop = mozScrollFix;
			return this;
		}
		return this;
	},

	//Set Selection in text
	setSelection: function(startPosition, endPosition) {
		startPosition = parseInt(startPosition);
		endPosition = parseInt(endPosition);
		
		var input = this.jquery ? this[0] : this; 
		input.focus ();
		if (typeof(input.selectionStart) != "number") {
			re = input.createTextRange();
			if (re.text.length < endPosition) {
				endPosition = re.text.length+1;
			}
		}
		if (endPosition < startPosition) {
			return this;
		}
		if (document.selection) { 
			var number = 0;
			var plus = 0;
			var position = 0;
			var plusEnd = 0;
			if (typeof(input.selectionStart) != "number") { // IE
				re.collapse(true); 
				re.moveEnd('character', endPosition); 
				re.moveStart('character', startPosition); 
				re.select(); 
				return this;
			} else if (typeof(input.selectionStart) == "number") {	  // Opera
				if (input.value.match(/\n/g) != null) {
					number = input.value.match(/\n/g).length;// number of EOL simbols
				}
				if (number > 0) {
					for (var i = 0; i <= number; i++) {
						var w = input.value.indexOf("\n", position);
						if (w != -1 && w < startPosition) {
							position = w + 1;
							plus++;
							plusEnd = plus;
						} else if (w != -1 && w >= startPosition && w <= endPosition) {
							if (w == startPosition + 1) {
								plus--;
								plusEnd--;
								position = w + 1;
								continue;
							}
							position = w + 1;
							plusEnd++;
						} else {
							i = number;
						}
					}
				}
				startPosition = startPosition + plus;
				endPosition = endPosition + plusEnd;
				input.selectionStart = startPosition; 
				input.selectionEnd = endPosition;
				input.focus ();
				return this;
			} else {
				input.focus ();
				return this;
			}
		}
		else if (input.selectionStart || input.selectionStart == 0) {   // MOZILLA support
			input.focus ();
			window.getSelection().removeAllRanges();
			input.selectionStart = startPosition; 
			input.selectionEnd = endPosition; 
			input.focus ();
			return this;
		} 
	},

	// insert text at current caret position
	insertAtCaretPos: function(inputStr) {
		var input = this.jquery ? this[0] : this; 
		var start;
		var end;
		var position;
		var s;
		var re;
		var rc;
		var point;
		var minus = 0;
		var number = 0;
		var mozScrollFix = ( input.scrollTop == undefined ) ? 0 : input.scrollTop; 
		var obj = document.getElementsByTagName('TEXTAREA');
		
		for (var pos = 0; pos < obj.length; pos++) {
			if (obj[pos] == input) {
				break;
			}
		}
		input.focus();
		if (document.selection && typeof(input.selectionStart) != "number") {
			if (input.value.match(/\n/g) != null) {
				number = input.value.match(/\n/g).length;// number of EOL simbols
			}
			point = parseInt(caretPositionAmp[pos]);
			if (number > 0) {
				for (var i = 0; i <= number; i++) {
					var w = input.value.indexOf("\n", position);
					if (w != -1 && w <= point) {
						position = w + 1;
						point = point - 1;
						minus++;
					} 
				}
			}
		}
		caretPositionAmp[pos] = parseInt(caretPositionAmp[pos]);

		// IE
		input.onkeyup = function() { // for IE because it loses caret position when focus changed
			if (document.selection && typeof(input.selectionStart) != "number") {
				input.focus();
				s = document.selection.createRange();
				re = input.createTextRange();
				rc = re.duplicate();
				re.moveToBookmark(s.getBookmark());
				rc.setEndPoint("EndToStart", re);
				caretPositionAmp[pos] = rc.text.length;
			}
			
		}

		input.onmouseup = function() { // for IE because it loses caret position when focus changed
			if (document.selection && typeof(input.selectionStart) != "number") {
				input.focus();
				s = document.selection.createRange();
				re = input.createTextRange();
				rc = re.duplicate();
				re.moveToBookmark(s.getBookmark());
				rc.setEndPoint("EndToStart", re);
				caretPositionAmp[pos] = rc.text.length;
			}
		}

		if (document.selection && typeof(input.selectionStart) != "number") {
			s = document.selection.createRange();
			if (s.text.length != 0) {
				return this;
			}
			re = input.createTextRange();
			textLength = re.text.length;
			rc = re.duplicate();
			re.moveToBookmark(s.getBookmark());
			rc.setEndPoint("EndToStart", re);
			start = rc.text.length; 
			if (caretPositionAmp[pos] > 0 && start ==0) {
				minus = caretPositionAmp[pos] - minus;
				re.move("character", minus);
				re.select();
				s = document.selection.createRange();
				caretPositionAmp[pos] += inputStr.length;
			} else if (!(caretPositionAmp[pos] >= 0) && textLength ==0) {
				s = document.selection.createRange();
				caretPositionAmp[pos] = inputStr.length + textLength;
			} else if (!(caretPositionAmp[pos] >= 0) && start ==0) {
				re.move("character", textLength);
				re.select();
				s = document.selection.createRange();
				caretPositionAmp[pos] = inputStr.length + textLength;
			} else if (!(caretPositionAmp[pos] >= 0) && start > 0) { 
				re.move("character", 0);
				document.selection.empty();
				re.select();
				s = document.selection.createRange();
				caretPositionAmp[pos] = start + inputStr.length;
			} else if (caretPositionAmp[pos] >= 0 && caretPositionAmp[pos] == textLength) { 
				if (textLength != 0) {
					re.move("character", textLength);
					re.select();
				} else {
					re.move("character", 0);
				}
				s = document.selection.createRange();
				caretPositionAmp[pos] = inputStr.length + textLength;
			} else if (caretPositionAmp[pos] >= 0 && start != 0 && caretPositionAmp[pos] >= start) { 
				minus = caretPositionAmp[pos] - start;
				re.move("character", minus);
				document.selection.empty();
				re.select();
				s = document.selection.createRange();
				caretPositionAmp[pos] = caretPositionAmp[pos] + inputStr.length; 
			} else if (caretPositionAmp[pos] >= 0 && start != 0 && caretPositionAmp[pos] < start) { 
				re.move("character", 0);
				document.selection.empty();
				re.select();
				s = document.selection.createRange();
				caretPositionAmp[pos] = caretPositionAmp[pos] + inputStr.length; 
			} else { 
				document.selection.empty();
				re.select();
				s = document.selection.createRange();
				caretPositionAmp[pos] = caretPositionAmp[pos] + inputStr.length; 
			} 
			s.text = inputStr; 
			input.focus();

			return this;
		} else if (typeof(input.selectionStart) == "number" && // MOZILLA support
				input.selectionStart == input.selectionEnd) {
			position = input.selectionStart + inputStr.length;
			start = input.selectionStart;
			end = input.selectionEnd;
			input.value = input.value.substr(0, start) + inputStr + input.value.substr(end);
			input.setSelectionRange(position, position); 
			input.scrollTop = mozScrollFix; 
			return this;
		}
		return this;
	},

	// Set caret position
	setCaretPos: function(inputStr) {
		var input = this.jquery ? this[0] : this; 
		var s;
		var re;
		var position;
		var number = 0;
		var minus = 0;
		var w;
		var obj = document.getElementsByTagName('TEXTAREA');
		
		for (var pos = 0; pos < obj.length; pos++) {
			if (obj[pos] == input) {
				break;
			}
		}
		input.focus();
		if (parseInt(inputStr) == 0) {
			return this;
		}
		//if (document.selection && typeof(input.selectionStart) == "number") {
		if (parseInt(inputStr) > 0) {
			inputStr = parseInt(inputStr) - 1;
			if (document.selection && typeof(input.selectionStart) == "number" && input.selectionStart == input.selectionEnd) {
				if (input.value.match(/\n/g) != null) {
					number = input.value.match(/\n/g).length;// number of EOL simbols
				}
				if (number > 0) {
					for (var i = 0; i <= number; i++) {
						w = input.value.indexOf("\n", position);
						if (w != -1 && w <= inputStr) {
							position = w + 1;
							inputStr = parseInt(inputStr) + 1;
						} 
					}
				}
			}
		} 
		else if (parseInt(inputStr) < 0) {
			inputStr = parseInt(inputStr) + 1;
			if (document.selection && typeof(input.selectionStart) != "number") {
				inputStr = input.value.length + parseInt(inputStr);
				if (input.value.match(/\n/g) != null) {
					number = input.value.match(/\n/g).length;// number of EOL simbols
				}
				if (number > 0) {
					for (var i = 0; i <= number; i++) {
						w = input.value.indexOf("\n", position);
						if (w != -1 && w <= inputStr) {
							position = w + 1;
							inputStr = parseInt(inputStr) - 1;
							minus += 1;
						} 
					}
					inputStr = inputStr + minus - number;
				}
			} else if (document.selection && typeof(input.selectionStart) == "number") {
				inputStr = input.value.length + parseInt(inputStr);
				if (input.value.match(/\n/g) != null) {
					number = input.value.match(/\n/g).length;// number of EOL simbols
				}
				if (number > 0) {
					inputStr = parseInt(inputStr) - number;
					for (var i = 0; i <= number; i++) {
						w = input.value.indexOf("\n", position);
						if (w != -1 && w <= (inputStr)) {
							position = w + 1;
							inputStr = parseInt(inputStr) + 1;
							minus += 1;
						} 
					}
				}
			} else { inputStr = input.value.length + parseInt(inputStr); }
		} else { return this; }
		// IE
		if (document.selection && typeof(input.selectionStart) != "number") {
			s = document.selection.createRange();
			if (s.text != 0) {
				return this;
			}
			re = input.createTextRange();
			re.collapse(true);
			re.moveEnd('character', inputStr);
			re.moveStart('character', inputStr);
			re.select();
			caretPositionAmp[pos] = inputStr;
			return this;
		} else if (typeof(input.selectionStart) == "number" && // MOZILLA support
				input.selectionStart == input.selectionEnd) {
			input.setSelectionRange(inputStr, inputStr); 
			return this;
		}
		return this;
	},

	countCharacters: function(str) {
		var input = this.jquery ? this[0] : this;
		if (input.value.match(/\r/g) != null) {
			return input.value.length - input.value.match(/\r/g).length;
		}
		return input.value.length;
	},

	setMaxLength: function(max, f) {
		this.each(function() {
			var input = this.jquery ? this[0] : this;
			var type = input.type;
			var isSelected;	
			var maxCharacters;
			// remove limit if input is a negative number
			if (parseInt(max) < 0) {
				max=100000000;
			}
			if (type == "text") {
				input.maxLength = max;
			}
			if (type == "textarea" || type == "text") {
				input.onkeypress = function(e) {
					var spacesR = input.value.match(/\r/g);
					maxCharacters = max;
					if (spacesR != null) {
						maxCharacters = parseInt(maxCharacters) + spacesR.length;
					}
					// get event
					var key = e || event;
					var keyCode = key.keyCode;
					// check if any part of text is selected
					if (document.selection) {
						isSelected = document.selection.createRange().text.length > 0;
					} else {
						isSelected = input.selectionStart != input.selectionEnd;
					}
					if (input.value.length >= maxCharacters && (keyCode > 47 || keyCode == 32 ||
							keyCode == 0 || keyCode == 13) && !key.ctrlKey && !key.altKey && !isSelected) {
						input.value = input.value.substring(0,maxCharacters);
						if (typeof(f) == "function") { f() } //callback function
						return false;
					}
				}
				input.onkeyup = function() { 
					var spacesR = input.value.match(/\r/g);
					var plus = 0;
					var position = 0;
					maxCharacters = max;
					if (spacesR != null) {
						for (var i = 0; i <= spacesR.length; i++) {
							if (input.value.indexOf("\n", position) <= parseInt(max)) {
								plus++;
								position = input.value.indexOf("\n", position) + 1;
							}
						}
						maxCharacters = parseInt(max) + plus;
					} 
					if (input.value.length > maxCharacters) {  
						input.value = input.value.substring(0, maxCharacters); 
						if (typeof(f) == "function") { f() }
						return this;
					}
				}
			} else { return this; }
		})
		return this;
	}
}); //fgnass.github.com/spin.js#v1.2.8
!function(window, document, undefined) {

  /**
   * Copyright (c) 2011 Felix Gnass [fgnass at neteye dot de]
   * Licensed under the MIT license
   */

  var prefixes = ['webkit', 'Moz', 'ms', 'O'] /* Vendor prefixes */
    , animations = {} /* Animation rules keyed by their name */
    , useCssAnimations

  /**
   * Utility function to create elements. If no tag name is given,
   * a DIV is created. Optionally properties can be passed.
   */
  function createEl(tag, prop) {
    var el = document.createElement(tag || 'div')
      , n

    for(n in prop) el[n] = prop[n]
    return el
  }

  /**
   * Appends children and returns the parent.
   */
  function ins(parent /* child1, child2, ...*/) {
    for (var i=1, n=arguments.length; i<n; i++)
      parent.appendChild(arguments[i])

    return parent
  }

  /**
   * Insert a new stylesheet to hold the @keyframe or VML rules.
   */
  var sheet = function() {
    var el = createEl('style', {type : 'text/css'})
    ins(document.getElementsByTagName('head')[0], el)
    return el.sheet || el.styleSheet
  }()

  /**
   * Creates an opacity keyframe animation rule and returns its name.
   * Since most mobile Webkits have timing issues with animation-delay,
   * we create separate rules for each line/segment.
   */
  function addAnimation(alpha, trail, i, lines) {
    var name = ['opacity', trail, ~~(alpha*100), i, lines].join('-')
      , start = 0.01 + i/lines*100
      , z = Math.max(1 - (1-alpha) / trail * (100-start), alpha)
      , prefix = useCssAnimations.substring(0, useCssAnimations.indexOf('Animation')).toLowerCase()
      , pre = prefix && '-'+prefix+'-' || ''

    if (!animations[name]) {
      sheet.insertRule(
        '@' + pre + 'keyframes ' + name + '{' +
        '0%{opacity:' + z + '}' +
        start + '%{opacity:' + alpha + '}' +
        (start+0.01) + '%{opacity:1}' +
        (start+trail) % 100 + '%{opacity:' + alpha + '}' +
        '100%{opacity:' + z + '}' +
        '}', sheet.cssRules.length)

      animations[name] = 1
    }
    return name
  }

  /**
   * Tries various vendor prefixes and returns the first supported property.
   **/
  function vendor(el, prop) {
    var s = el.style
      , pp
      , i

    if(s[prop] !== undefined) return prop
    prop = prop.charAt(0).toUpperCase() + prop.slice(1)
    for(i=0; i<prefixes.length; i++) {
      pp = prefixes[i]+prop
      if(s[pp] !== undefined) return pp
    }
  }

  /**
   * Sets multiple style properties at once.
   */
  function css(el, prop) {
    for (var n in prop)
      el.style[vendor(el, n)||n] = prop[n]

    return el
  }

  /**
   * Fills in default values.
   */
  function merge(obj) {
    for (var i=1; i < arguments.length; i++) {
      var def = arguments[i]
      for (var n in def)
        if (obj[n] === undefined) obj[n] = def[n]
    }
    return obj
  }

  /**
   * Returns the absolute page-offset of the given element.
   */
  function pos(el) {
    var o = { x:el.offsetLeft, y:el.offsetTop }
    while((el = el.offsetParent))
      o.x+=el.offsetLeft, o.y+=el.offsetTop

    return o
  }

  var defaults = {
    lines: 12,            // The number of lines to draw
    length: 7,            // The length of each line
    width: 5,             // The line thickness
    radius: 10,           // The radius of the inner circle
    rotate: 0,            // Rotation offset
    corners: 1,           // Roundness (0..1)
    color: '#000',        // #rgb or #rrggbb
    speed: 1,             // Rounds per second
    trail: 100,           // Afterglow percentage
    opacity: 1/4,         // Opacity of the lines
    fps: 20,              // Frames per second when using setTimeout()
    zIndex: 2e9,          // Use a high z-index by default
    className: 'spinner', // CSS class to assign to the element
    top: 'auto',          // center vertically
    left: 'auto',         // center horizontally
    position: 'relative'  // element position
  }

  /** The constructor */
  function Spinner(o) {
    if (!this.spin) return new Spinner(o)
    this.opts = merge(o || {}, Spinner.defaults, defaults)
  }

  Spinner.defaults = {}

  merge(Spinner.prototype, {
    spin: function(target) {
      this.stop()
      var self = this
        , o = self.opts
        , el = self.el = css(createEl(0, {className: o.className}), {position: o.position, width: 0, zIndex: o.zIndex})
        , mid = o.radius+o.length+o.width
        , ep // element position
        , tp // target position

      if (target) {
        target.insertBefore(el, target.firstChild||null)
        tp = pos(target)
        ep = pos(el)
        css(el, {
          left: (o.left == 'auto' ? tp.x-ep.x + (target.offsetWidth >> 1) : parseInt(o.left, 10) + mid) + 'px',
          top: (o.top == 'auto' ? tp.y-ep.y + (target.offsetHeight >> 1) : parseInt(o.top, 10) + mid)  + 'px'
        })
      }

      el.setAttribute('aria-role', 'progressbar')
      self.lines(el, self.opts)

      if (!useCssAnimations) {
        // No CSS animation support, use setTimeout() instead
        var i = 0
          , fps = o.fps
          , f = fps/o.speed
          , ostep = (1-o.opacity) / (f*o.trail / 100)
          , astep = f/o.lines

        ;(function anim() {
          i++;
          for (var s=o.lines; s; s--) {
            var alpha = Math.max(1-(i+s*astep)%f * ostep, o.opacity)
            self.opacity(el, o.lines-s, alpha, o)
          }
          self.timeout = self.el && setTimeout(anim, ~~(1000/fps))
        })()
      }
      return self
    },

    stop: function() {
      var el = this.el
      if (el) {
        clearTimeout(this.timeout)
        if (el.parentNode) el.parentNode.removeChild(el)
        this.el = undefined
      }
      return this
    },

    lines: function(el, o) {
      var i = 0
        , seg

      function fill(color, shadow) {
        return css(createEl(), {
          position: 'absolute',
          width: (o.length+o.width) + 'px',
          height: o.width + 'px',
          background: color,
          boxShadow: shadow,
          transformOrigin: 'left',
          transform: 'rotate(' + ~~(360/o.lines*i+o.rotate) + 'deg) translate(' + o.radius+'px' +',0)',
          borderRadius: (o.corners * o.width>>1) + 'px'
        })
      }

      for (; i < o.lines; i++) {
        seg = css(createEl(), {
          position: 'absolute',
          top: 1+~(o.width/2) + 'px',
          transform: o.hwaccel ? 'translate3d(0,0,0)' : '',
          opacity: o.opacity,
          animation: useCssAnimations && addAnimation(o.opacity, o.trail, i, o.lines) + ' ' + 1/o.speed + 's linear infinite'
        })

        if (o.shadow) ins(seg, css(fill('#000', '0 0 4px ' + '#000'), {top: 2+'px'}))

        ins(el, ins(seg, fill(o.color, '0 0 1px rgba(0,0,0,.1)')))
      }
      return el
    },

    opacity: function(el, i, val) {
      if (i < el.childNodes.length) el.childNodes[i].style.opacity = val
    }

  })

  /////////////////////////////////////////////////////////////////////////
  // VML rendering for IE
  /////////////////////////////////////////////////////////////////////////

  /**
   * Check and init VML support
   */
  ;(function() {

    function vml(tag, attr) {
      return createEl('<' + tag + ' xmlns="urn:schemas-microsoft.com:vml" class="spin-vml">', attr)
    }

    var s = css(createEl('group'), {behavior: 'url(#default#VML)'})

    if (!vendor(s, 'transform') && s.adj) {

      // VML support detected. Insert CSS rule ...
      sheet.addRule('.spin-vml', 'behavior:url(#default#VML)')

      Spinner.prototype.lines = function(el, o) {
        var r = o.length+o.width
          , s = 2*r

        function grp() {
          return css(
            vml('group', {
              coordsize: s + ' ' + s,
              coordorigin: -r + ' ' + -r
            }),
            { width: s, height: s }
          )
        }

        var margin = -(o.width+o.length)*2 + 'px'
          , g = css(grp(), {position: 'absolute', top: margin, left: margin})
          , i

        function seg(i, dx, filter) {
          ins(g,
            ins(css(grp(), {rotation: 360 / o.lines * i + 'deg', left: ~~dx}),
              ins(css(vml('roundrect', {arcsize: o.corners}), {
                  width: r,
                  height: o.width,
                  left: o.radius,
                  top: -o.width>>1,
                  filter: filter
                }),
                vml('fill', {color: o.color, opacity: o.opacity}),
                vml('stroke', {opacity: 0}) // transparent stroke to fix color bleeding upon opacity change
              )
            )
          )
        }

        if (o.shadow)
          for (i = 1; i <= o.lines; i++)
            seg(i, -2, 'progid:DXImageTransform.Microsoft.Blur(pixelradius=2,makeshadow=1,shadowopacity=.3)')

        for (i = 1; i <= o.lines; i++) seg(i)
        return ins(el, g)
      }

      Spinner.prototype.opacity = function(el, i, val, o) {
        var c = el.firstChild
        o = o.shadow && o.lines || 0
        if (c && i+o < c.childNodes.length) {
          c = c.childNodes[i+o]; c = c && c.firstChild; c = c && c.firstChild
          if (c) c.opacity = val
        }
      }
    }
    else
      useCssAnimations = vendor(s, 'animation')
  })()

  if (typeof define == 'function' && define.amd)
    define(function() { return Spinner })
  else
    window.Spinner = Spinner

}(window, document);
/*

You can now create a spinner using any of the variants below:

$("#el").spin(); // Produces default Spinner using the text color of #el.
$("#el").spin("small"); // Produces a 'small' Spinner using the text color of #el.
$("#el").spin("large", "white"); // Produces a 'large' Spinner in white (or any valid CSS color).
$("#el").spin({ ... }); // Produces a Spinner using your custom settings.

$("#el").spin(false); // Kills the spinner.

*/
(function($) {
   $.fn.spin = function(opts, color) {
      var presets = {
         "tiny": { lines: 8, length: 2, width: 2, radius: 3 },
         "small": { lines: 8, length: 4, width: 3, radius: 5 },
         "large": { lines: 10, length: 8, width: 4, radius: 8 }
      };
      if (Spinner) {
         return this.each(function() {
            var $this = $(this),
               data = $this.data();

            if (data.spinner) {
               data.spinner.stop();
               delete data.spinner;
            }
            if (opts !== false) {
               if (typeof opts === "string") {
                  if (opts in presets) {
                     opts = presets[opts];
                  } else {
                     opts = {};
                  }
                  if (color) {
                     opts.color = color;
                  }
               }
               data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
            }
         });
      } else {
         throw "Spinner class not available.";
      }
   };
})(jQuery);

/*
  Implement Github like autocomplete mentions
  http://ichord.github.com/At.js

  Copyright (c) 2013 chord.luo@gmail.com
  Licensed under the MIT license.
*/


(function() {

  (function(factory) {
    if (typeof define === 'function' && define.amd) {
      return define(['jquery'], factory);
    } else {
      return factory(window.jQuery);
    }
  })(function($) {
    var Controller, DEFAULT_CALLBACKS, DEFAULT_TPL, KEY_CODE, Mirror, View;
    Mirror = (function() {

      Mirror.prototype.css_attr = ["overflowY", "height", "width", "paddingTop", "paddingLeft", "paddingRight", "paddingBottom", "marginTop", "marginLeft", "marginRight", "marginBottom", 'fontFamily', 'borderStyle', 'borderWidth', 'wordWrap', 'fontSize', 'lineHeight', 'overflowX'];

      function Mirror($inputor) {
        this.$inputor = $inputor;
      }

      Mirror.prototype.copy_inputor_css = function() {
        var css,
          _this = this;
        css = {
          position: 'absolute',
          left: -9999,
          top: 0,
          zIndex: -20000,
          'white-space': 'pre-wrap'
        };
        $.each(this.css_attr, function(i, p) {
          return css[p] = _this.$inputor.css(p);
        });
        return css;
      };

      Mirror.prototype.create = function(html) {
        this.$mirror = $('<div></div>');
        this.$mirror.css(this.copy_inputor_css());
        this.$mirror.html(html);
        this.$inputor.after(this.$mirror);
        return this;
      };

      Mirror.prototype.get_flag_rect = function() {
        var $flag, pos, rect;
        $flag = this.$mirror.find("span#flag");
        pos = $flag.position();
        rect = {
          left: pos.left,
          top: pos.top,
          bottom: $flag.height() + pos.top
        };
        this.$mirror.remove();
        return rect;
      };

      return Mirror;

    })();
    KEY_CODE = {
      DOWN: 40,
      UP: 38,
      ESC: 27,
      TAB: 9,
      ENTER: 13
    };
    DEFAULT_CALLBACKS = {
      data_refactor: function(data) {
        return $.map(data, function(item, k) {
          if (!$.isPlainObject(item)) {
            item = {
              name: item
            };
          }
          return item;
        });
      },
      matcher: function(flag, subtext) {
        var match, matched, regexp;
        regexp = new RegExp(flag + '([A-Za-z0-9_\+\-]*)$|' + flag + '([^\\x00-\\xff]*)$', 'gi');
        match = regexp.exec(subtext);
        matched = null;
        if (match) {
          matched = match[2] ? match[2] : match[1];
        }
        return matched;
      },
      filter: function(query, data, search_key) {
        var _this = this;
        return $.map(data, function(item, i) {
          var name;
          name = $.isPlainObject(item) ? item[search_key] : item;
          if (name.toLowerCase().indexOf(query) >= 0) {
            return item;
          }
        });
      },
      remote_filter: function(params, url, render_view) {
        return $.ajax(url, {
          data: params,
          success: function(data) {
            return render_view(data);
          }
        });
      },
      sorter: function(query, items, search_key) {
        var item, results, text, _i, _len;
        if (!query) {
          items;

        }
        results = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          text = item[search_key];
          item.order = text.toLowerCase().indexOf(query);
          results.push(item);
        }
        return results.sort(function(a, b) {
          return a.order - b.order;
        });
      },
      tpl_eval: function(tpl, map) {
        var el;
        try {
          return el = tpl.replace(/\$\{([^\}]*)\}/g, function(tag, key, pos) {
            return map[key];
          });
        } catch (error) {
          return "";
        }
      },
      highlighter: function(li, query) {
        if (!query) {
          return li;
        }
        return li.replace(new RegExp(">\\s*(\\w*)(" + query.replace("+", "\\+") + ")(\\w*)\\s*<", 'ig'), function(str, $1, $2, $3) {
          return '> ' + $1 + '<strong>' + $2 + '</strong>' + $3 + ' <';
        });
      },
      selector: function($li) {
        if ($li.length > 0) {
          return this.replace_str($li.data("value") || "");
        }
      }
    };
    Controller = (function() {

      function Controller(inputor) {
        this.settings = {};
        this.common_settings = {};
        this.pos = 0;
        this.flags = null;
        this.current_flag = null;
        this.query = null;
        this.$inputor = $(inputor);
        this.mirror = new Mirror(this.$inputor);
        this.common_settings = $.extend({}, $.fn.atwho["default"]);
        this.view = new View(this, this.$el);
        this.listen();
      }

      Controller.prototype.listen = function() {
        var _this = this;
        return this.$inputor.on('keyup.atwho', function(e) {
          return _this.on_keyup(e);
        }).on('keydown.atwho', function(e) {
          return _this.on_keydown(e);
        }).on('scroll.atwho', function(e) {
          return _this.view.hide();
        }).on('blur.atwho', function(e) {
          return _this.view.hide(_this.get_opt("display_timeout"));
        });
      };

      Controller.prototype.reg = function(flag, settings) {
        var current_settings, data;
        current_settings = {};
        current_settings = $.isPlainObject(flag) ? this.common_settings = $.extend({}, this.common_settings, flag) : !this.settings[flag] ? this.settings[flag] = $.extend({}, settings) : this.settings[flag] = $.extend({}, this.settings[flag], settings);
        data = current_settings["data"];
        if (typeof data === "string") {
          current_settings["data"] = data;
        } else if (data) {
          current_settings["data"] = this.callbacks("data_refactor").call(this, data);
        }
        return this;
      };

      Controller.prototype.trigger = function(name, data) {
        data || (data = []);
        data.push(this);
        return this.$inputor.trigger("" + name + ".atwho", data);
      };

      Controller.prototype.data = function() {
        return this.get_opt("data");
      };

      Controller.prototype.callbacks = function(func_name) {
        var func;
        if (!(func = this.get_opt("callbacks", {})[func_name])) {
          func = this.common_settings["callbacks"][func_name];
        }
        return func;
      };

      Controller.prototype.get_opt = function(key, default_value) {
        var value;
        try {
          if (this.current_flag) {
            value = this.settings[this.current_flag][key];
          }
          if (value === void 0) {
            value = this.common_settings[key];
          }
          return value = value === void 0 ? default_value : value;
        } catch (e) {
          return value = default_value === void 0 ? null : default_value;
        }
      };

      Controller.prototype.rect = function() {
        var $inputor, Sel, at_rect, bottom, format, html, offset, start_range, x, y;
        $inputor = this.$inputor;
        if (document.selection) {
          Sel = document.selection.createRange();
          x = Sel.boundingLeft + $inputor.scrollLeft();
          y = Sel.boundingTop + $(window).scrollTop() + $inputor.scrollTop();
          bottom = y + Sel.boundingHeight;
          return {
            top: y - 2,
            left: x - 2,
            bottom: bottom - 2
          };
        }
        format = function(value) {
          return value.replace(/</g, '&lt').replace(/>/g, '&gt').replace(/`/g, '&#96').replace(/"/g, '&quot').replace(/\r\n|\r|\n/g, "<br />");
        };
        /* 克隆完inputor后将原来的文本内容根据
          @的位置进行分块,以获取@块在inputor(输入框)里的position
        */

        start_range = $inputor.val().slice(0, this.pos - 1);
        html = "<span>" + format(start_range) + "</span>";
        html += "<span id='flag'>?</span>";
        /*
                将inputor的 offset(相对于document)
                和@在inputor里的position相加
                就得到了@相对于document的offset.
                当然,还要加上行高和滚动条的偏移量.
        */

        offset = $inputor.offset();
        at_rect = this.mirror.create(html).get_flag_rect();
        x = offset.left + at_rect.left - $inputor.scrollLeft();
        y = offset.top - $inputor.scrollTop();
        bottom = y + at_rect.bottom;
        y += at_rect.top;
        return {
          top: y,
          left: x,
          bottom: bottom + 2
        };
      };

      Controller.prototype.catch_query = function() {
        var caret_pos, content, end, query, start, subtext,
          _this = this;
        content = this.$inputor.val();
        caret_pos = this.$inputor.caretPos();
        /* 向在插入符前的的文本进行正则匹配
         * 考虑会有多个 @ 的存在, 匹配离插入符最近的一个
        */

        subtext = content.slice(0, caret_pos);
        query = null;
        $.each(this.settings, function(flag, settings) {
          query = _this.callbacks("matcher").call(_this, flag, subtext);
          if (query != null) {
            _this.current_flag = flag;
            return false;
          }
        });
        if (typeof query === "string" && query.length <= 20) {
          start = caret_pos - query.length;
          end = start + query.length;
          this.pos = start;
          query = {
            'text': query.toLowerCase(),
            'head_pos': start,
            'end_pos': end
          };
          this.trigger("matched", [this.current_flag, query.text]);
        } else {
          this.view.hide();
        }
        return this.query = query;
      };

      Controller.prototype.replace_str = function(str) {
        var $inputor, flag_len, source, start_str, text;
        $inputor = this.$inputor;
        source = $inputor.val();
        flag_len = this.get_opt("display_flag") ? 0 : this.current_flag.length;
        start_str = source.slice(0, (this.query['head_pos'] || 0) - flag_len);
        text = "" + start_str + str + " " + (source.slice(this.query['end_pos'] || 0));
        $inputor.val(text);
        $inputor.caretPos(start_str.length + str.length + 1);
        return $inputor.change();
      };

      Controller.prototype.on_keyup = function(e) {
        switch (e.keyCode) {
          case KEY_CODE.ESC:
            e.preventDefault();
            this.view.hide();
            break;
          case KEY_CODE.DOWN:
          case KEY_CODE.UP:
            $.noop();
            break;
          default:
            this.look_up();
        }
        return e.stopPropagation();
      };

      Controller.prototype.on_keydown = function(e) {
        if (!this.view.visible()) {
          return;
        }
        switch (e.keyCode) {
          case KEY_CODE.ESC:
            e.preventDefault();
            this.view.hide();
            break;
          case KEY_CODE.UP:
            e.preventDefault();
            this.view.prev();
            break;
          case KEY_CODE.DOWN:
            e.preventDefault();
            this.view.next();
            break;
          case KEY_CODE.TAB:
          case KEY_CODE.ENTER:
            if (!this.view.visible()) {
              return;
            }
            e.preventDefault();
            this.view.choose();
            break;
          default:
            $.noop();
        }
        return e.stopPropagation();
      };

      Controller.prototype.render_view = function(data) {
        var search_key;
        search_key = this.get_opt("search_key");
        data = this.callbacks("sorter").call(this, this.query.text, data, search_key);
        data = data.splice(0, this.get_opt('limit'));
        return this.view.render(data);
      };

      Controller.prototype.look_up = function() {
        var data, origin_data, params, query, search_key;
        query = this.catch_query();
        if (!query) {
          return false;
        }
        origin_data = this.get_opt("data");
        search_key = this.get_opt("search_key");
        if (typeof origin_data === "string") {
          params = {
            q: query.text,
            limit: this.get_opt("limit")
          };
          this.callbacks('remote_filter').call(this, params, origin_data, $.proxy(this.render_view, this));
        } else if ((data = this.callbacks('filter').call(this, query.text, origin_data, search_key))) {
          this.render_view(data);
        } else {
          this.view.hide();
        }
        return $.noop();
      };

      return Controller;

    })();
    View = (function() {

      function View(controller) {
        this.controller = controller;
        this.id = this.controller.get_opt("view_id", "at-view");
        this.timeout_id = null;
        this.$el = $("#" + this.id);
        this.create_view();
      }

      View.prototype.create_view = function() {
        var $menu, tpl,
          _this = this;
        if (this.exist()) {
          return;
        }
        tpl = "<div id='" + this.id + "' class='at-view'><ul id='" + this.id + "-ul'></ul></div>";
        $("body").append(tpl);
        this.$el = $("#" + this.id);
        $menu = this.$el.find('ul');
        return $menu.on('mouseenter.view', 'li', function(e) {
          $menu.find('.cur').removeClass('cur');
          return $(e.currentTarget).addClass('cur');
        }).on('click', function(e) {
          e.stopPropagation();
          e.preventDefault();
          return _this.$el.data("_view").choose();
        });
      };

      View.prototype.exist = function() {
        return $("#" + this.id).length > 0;
      };

      View.prototype.visible = function() {
        return this.$el.is(":visible");
      };

      View.prototype.choose = function() {
        var $li;
        $li = this.$el.find(".cur");
        this.controller.callbacks("selector").call(this.controller, $li);
        this.controller.trigger("choose", [$li]);
        return this.hide();
      };

      View.prototype.reposition = function() {
        var offset, rect;
        rect = this.controller.rect();
        if (rect.bottom + this.$el.height() - $(window).scrollTop() > $(window).height()) {
          rect.bottom = rect.top - this.$el.height();
        }
        offset = {
          left: rect.left,
          top: rect.bottom
        };
        this.$el.offset(offset);
        return this.controller.trigger("reposition", [offset]);
      };

      View.prototype.next = function() {
        var cur, next;
        cur = this.$el.find('.cur').removeClass('cur');
        next = cur.next();
        if (!next.length) {
          next = $(this.$el.find('li')[0]);
        }
        return next.addClass('cur');
      };

      View.prototype.prev = function() {
        var cur, prev;
        cur = this.$el.find('.cur').removeClass('cur');
        prev = cur.prev();
        if (!prev.length) {
          prev = this.$el.find('li').last();
        }
        return prev.addClass('cur');
      };

      View.prototype.show = function() {
        if (!this.visible()) {
          this.$el.show();
        }
        return this.reposition();
      };

      View.prototype.hide = function(time) {
        var callback,
          _this = this;
        if (isNaN(time)) {
          if (this.visible()) {
            return this.$el.hide();
          }
        } else {
          callback = function() {
            return _this.hide();
          };
          clearTimeout(this.timeout_id);
          return this.timeout_id = setTimeout(callback, time);
        }
      };

      View.prototype.clear = function() {
        return this.$el.find('ul').empty();
      };

      View.prototype.render = function(list) {
        var $ul, tpl,
          _this = this;
        if (!$.isArray(list)) {
          return false;
        }
        if (list.length <= 0) {
          this.hide();
          return true;
        }
        this.clear();
        this.$el.data("_view", this);
        $ul = this.$el.find('ul');
        tpl = this.controller.get_opt('tpl', DEFAULT_TPL);
        $.each(list, function(i, item) {
          var $li, li;
          li = _this.controller.callbacks("tpl_eval").call(_this.controller, tpl, item);
          $li = $(_this.controller.callbacks("highlighter").call(_this.controller, li, _this.controller.query.text));
          $li.data("info", item);
          return $ul.append($li);
        });
        this.show();
        return $ul.find("li:eq(0)").addClass("cur");
      };

      return View;

    })();
    DEFAULT_TPL = "<li data-value='${name}'>${name}</li>";
    $.fn.atwho = function(flag, options) {
      return this.filter('textarea, input').each(function() {
        var $this, data;
        $this = $(this);
        data = $this.data("atwho");
        if (!data) {
          $this.data('atwho', (data = new Controller(this)));
        }
        return data.reg(flag, options);
      });
    };
    $.fn.atwho.Controller = Controller;
    $.fn.atwho.View = View;
    $.fn.atwho.Mirror = Mirror;
    return $.fn.atwho["default"] = {
      data: null,
      search_key: "name",
      callbacks: DEFAULT_CALLBACKS,
      limit: 5,
      display_flag: true,
      display_timeout: 300,
      tpl: DEFAULT_TPL
    };
  });

}).call(this);


/*
  Implement Github like autocomplete mentions
  http://ichord.github.com/At.js

  Copyright (c) 2013 chord.luo@gmail.com
  Licensed under the MIT license.
*/


/*
本插件操作 textarea 或者 input 内的插入符
只实现了获得插入符在文本框中的位置，我设置
插入符的位置.
*/


(function() {

  (function(factory) {
    if (typeof exports === 'object') {
      return factory(require('jquery'));
    } else if (typeof define === 'function' && define.amd) {
      return define(['jquery']);
    } else {
      return factory(window.jQuery);
    }
  })(function($) {
    var getCaretPos, setCaretPos;
    getCaretPos = function(inputor) {
      var end, endRange, len, normalizedValue, pos, range, start, textInputRange;
      if (document.selection) {
        /*
                #assume we select "HATE" in the inputor such as textarea -> { }.
                 *               start end-point.
                 *              /
                 * <  I really [HATE] IE   > between the brackets is the selection range.
                 *                   \
                 *                    end end-point.
        */

        range = document.selection.createRange();
        pos = 0;
        if (range && range.parentElement() === inputor) {
          normalizedValue = inputor.value.replace(/\r\n/g, "\n");
          /* SOMETIME !!!
           "/r/n" is counted as two char.
            one line is two, two will be four. balalala.
            so we have to using the normalized one's length.;
          */

          len = normalizedValue.length;
          /*
                       <[  I really HATE IE   ]>:
                        the whole content in the inputor will be the textInputRange.
          */

          textInputRange = inputor.createTextRange();
          /*                 _here must be the position of bookmark.
                           /
             <[  I really [HATE] IE   ]>
              [---------->[           ] : this is what moveToBookmark do.
             <   I really [[HATE] IE   ]> : here is result.
                            \ two brackets in should be in line.
          */

          textInputRange.moveToBookmark(range.getBookmark());
          endRange = inputor.createTextRange();
          /*  [--------------------->[] : if set false all end-point goto end.
            <  I really [[HATE] IE  []]>
          */

          endRange.collapse(false);
          /*
                                    ___VS____
                                   /         \
                     <   I really [[HATE] IE []]>
                                              \_endRange end-point.

                    " > -1" mean the start end-point will be the same or right to the end end-point
                   * simplelly, all in the end.
          */

          if (textInputRange.compareEndPoints("StartToEnd", endRange) > -1) {
            start = end = len;
          } else {
            /*
                                I really |HATE] IE   ]>
                                       <-|
                              I really[ [HATE] IE   ]>
                                    <-[
                            I reall[y  [HATE] IE   ]>

                          will return how many unit have moved.
            */

            start = -textInputRange.moveStart("character", -len);
            end = -textInputRange.moveEnd("character", -len);
          }
        }
      } else {
        start = inputor.selectionStart;
      }
      return start;
    };
    setCaretPos = function(inputor, pos) {
      var range;
      if (document.selection) {
        range = inputor.createTextRange();
        range.move("character", pos);
        return range.select();
      } else {
        return inputor.setSelectionRange(pos, pos);
      }
    };
    return $.fn.caretPos = function(pos) {
      var inputor;
      inputor = this[0];
      inputor.focus();
      if (pos) {
        return setCaretPos(inputor, pos);
      } else {
        return getCaretPos(inputor);
      }
    };
  });

}).call(this);
/*
 * Parsley.js allows you to verify your form inputs frontend side, without writing a line of javascript. Or so..
 *
 * Author: Guillaume Potier - @guillaumepotier
*/

!function ($) {

  'use strict';

  /**
  * Validator class stores all constraints functions and associated messages.
  * Provides public interface to add, remove or modify them
  *
  * @class Validator
  * @constructor
  */
  var Validator = function ( options ) {
    /**
    * Error messages
    *
    * @property messages
    * @type {Object}
    */
    this.messages = {
        defaultMessage: "This value seems to be invalid."
      , type: {
            email:      "This value should be a valid email."
          , url:        "This value should be a valid url."
          , urlstrict:  "This value should be a valid url."
          , number:     "This value should be a valid number."
          , digits:     "This value should be digits."
          , dateIso:    "This value should be a valid date (YYYY-MM-DD)."
          , alphanum:   "This value should be alphanumeric."
        }
      , notnull:        "This value should not be null."
      , notblank:       "This value should not be blank."
      , required:       "This value is required."
      , regexp:         "This value seems to be invalid."
      , min:            "This value should be greater than %s."
      , max:            "This value should be lower than %s."
      , range:          "This value should be between %s and %s."
      , minlength:      "This value is too short. It should have %s characters or more."
      , maxlength:      "This value is too long. It should have %s characters or less."
      , rangelength:    "This value length is invalid. It should be between %s and %s characters long."
      , mincheck:       "You must select at least %s choices."
      , maxcheck:       "You must select %s choices or less."
      , rangecheck:     "You must select between %s and %s choices."
      , equalto:        "This value should be the same."
    },

    this.init( options );
  };

  Validator.prototype = {

    constructor: Validator

    /**
    * Validator list. Built-in validators functions
    *
    * @property validators
    * @type {Object}
    */
    , validators: {
      notnull: function ( val ) {
        return val.length > 0;
      }

      , notblank: function ( val ) {
        return null !== val && '' !== val.replace( /^\s+/g, '' ).replace( /\s+$/g, '' );
      }

      // Works on all inputs. val is object for checkboxes
      , required: function ( val ) {

        // for checkboxes and select multiples. Check there is at least one required value
        if ( 'object' === typeof val ) {
          for ( var i in val ) {
            if ( this.required( val[ i ] ) ) {
              return true;
            }
          }

          return false;
        }

        return this.notnull( val ) && this.notblank( val );
      }

      , type: function ( val, type ) {
        var regExp;

        switch ( type ) {
          case 'number':
            regExp = /^-?(?:\d+|\d{1,3}(?:,\d{3})+)?(?:\.\d+)?$/;
            break;
          case 'digits':
            regExp = /^\d+$/;
            break;
          case 'alphanum':
            regExp = /^\w+$/;
            break;
          case 'email':
            regExp = /^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$/i;
            break;
          case 'url':
            val = new RegExp( '(https?|s?ftp|git)', 'i' ).test( val ) ? val : 'http://' + val;
            /* falls through */
          case 'urlstrict':
            regExp = /^(https?|s?ftp|git):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i;
            break;
          case 'dateIso':
            regExp = /^(\d{4})\D?(0[1-9]|1[0-2])\D?([12]\d|0[1-9]|3[01])$/;
            break;
          default:
            return false;
        }

        // test regExp if not null
        return '' !== val ? regExp.test( val ) : false;
      }

      , regexp: function ( val, regExp ) {
        return new RegExp( regExp, 'i' ).test( val );
      }

      , minlength: function ( val, min ) {
        return val.length >= min;
      }

      , maxlength: function ( val, max ) {
        return val.length <= max;
      }

      , rangelength: function ( val, arrayRange ) {
        return this.minlength( val, arrayRange[ 0 ] ) && this.maxlength( val, arrayRange[ 1 ] );
      }

      , min: function ( val, min ) {
        return Number( val ) >= min;
      }

      , max: function ( val, max ) {
        return Number( val ) <= max;
      }

      , range: function ( val, arrayRange ) {
        return val >= arrayRange[ 0 ] && val <= arrayRange[ 1 ];
      }

      , equalto: function ( val, elem ) {
        return val === $( elem ).val();
      }

      , remote: function ( val, url, self ) {
        var result = null
          , data = {}
          , dataType = {};

        data[ self.$element.attr( 'name' ) ] = val;

        if ( 'undefined' !== typeof self.options.remoteDatatype ) {
          dataType = { dataType: self.options.remoteDatatype };
        }

        var manage = function ( isConstraintValid ) {
          self.updateConstraint( 'remote', 'isValid', isConstraintValid );
          self.manageValidationResult();
        };

        $.ajax( $.extend( {}, {
            url: url
          , data: data
          , async: self.async
          , method: self.options.remoteMethod || 'GET'
          , success: function ( response ) {
            manage( '1' === response
              || 'true' == response
              || ( 'object' === typeof response && 'undefined' !== typeof response.success )
              || new RegExp( 'success', 'i' ).test( response )
            );
          }
          , error: function ( response ) {
            manage( false );
          }
        }, dataType ) );

        if ( self.async ) {
          manage( result );
        }

        return result;
      }

      /**
      * Aliases for checkboxes constraints
      */
      , mincheck: function ( obj, val ) {
        return this.minlength( obj, val );
      }

      , maxcheck: function ( obj, val ) {
        return this.maxlength( obj, val);
      }

      , rangecheck: function ( obj, arrayRange ) {
        return this.rangelength( obj, arrayRange );
      }
    }

    /*
    * Register custom validators and messages
    */
    , init: function ( options ) {
      var customValidators = options.validators
        , customMessages = options.messages;

      var key;
      for ( key in customValidators ) {
        this.addValidator(key, customValidators[ key ]);
      }

      for ( key in customMessages ) {
        this.addMessage(key, customMessages[ key ]);
      }
    }

    /**
    * Replace %s placeholders by values
    *
    * @method formatMesssage
    * @param {String} message Message key
    * @param {Mixed} args Args passed by validators functions. Could be string, number or object
    * @return {String} Formatted string
    */
    , formatMesssage: function ( message, args ) {

      if ( 'object' === typeof args ) {
        for ( var i in args ) {
          message = this.formatMesssage( message, args[ i ] );
        }

        return message;
      }

      return message.replace(new RegExp( '%s', 'i' ), args);
    }

    /**
    * Add / override a validator in validators list
    *
    * @method addValidator
    * @param {String} name Validator name. Will automatically bindable through data-name=''
    * @param {Function} fn Validator function. Must return {Boolean}
    */
    , addValidator: function ( name, fn ) {
      this.validators[ name ] = fn;
    }

    /**
    * Add / override error message
    *
    * @method addMessage
    * @param {String} name Message name. Will automatically be binded to validator with same name
    * @param {String} message Message
    */
    , addMessage: function ( key, message, type ) {

      if ( 'undefined' !== typeof type && true === type ) {
        this.messages.type[ key ] = message;
        return;
      }

      // custom types messages are a bit tricky cuz' nested ;)
      if ( 'type' === key ) {
        for ( var i in message ) {
          this.messages.type[ i ] = message[ i ];
        }

        return;
      }

      this.messages[ key ] = message;
    }
  };

  /**
  * ParsleyField class manage each form field inside a validated Parsley form.
  * Returns if field valid or not depending on its value and constraints
  * Manage field error display and behavior, event triggers and more
  *
  * @class ParsleyField
  * @constructor
  */
  var ParsleyField = function ( element, options, type ) {
    this.options = options;
    this.Validator = new Validator( options );
    this.init( element, type || 'ParsleyField' );
  };

  ParsleyField.prototype = {

    constructor: ParsleyField

    /**
    * Set some properties, bind constraint validators and validation events
    *
    * @method init
    * @param {Object} element
    * @param {Object} options
    */
    , init: function ( element, type ) {
      this.type = type;
      this.isValid = true;
      this.element = element;
      this.validatedOnce = false;
      this.$element = $( element );
      this.val = this.$element.val();
      this.isRequired = false;
      this.constraints = [];

      // overriden by ParsleyItemMultiple if radio or checkbox input
      if ( 'undefined' === typeof this.isRadioOrCheckbox ) {
        this.isRadioOrCheckbox = false;
        this.hash = this.generateHash();
        this.errorClassHandler = this.options.errors.classHandler( element ) || this.$element;
      }

      // error ul dom management done only once at init
      this.ulErrorManagement();

      // bind some html5 properties
      this.bindHtml5Constraints();

      // bind validators to field
      this.addConstraints();

      // bind parsley events if validators have been registered
      if ( this.constraints.length ) {
        this.bindValidationEvents();
      }
    }

    /**
    * Bind some extra html5 types / validators
    *
    * @private
    * @method bindHtml5Constraints
    */
    , bindHtml5Constraints: function () {
      // add html5 required support + class required support
      if ( this.$element.hasClass( 'required' ) || this.$element.attr( 'required' ) ) {
        this.options.required = true;
      }

      // add html5 supported types & options
      if ( 'undefined' !== typeof this.$element.attr( 'type' ) && new RegExp( this.$element.attr( 'type' ), 'i' ).test( 'email url number range' ) ) {
        this.options.type = this.$element.attr( 'type' );

        // number and range types could have min and/or max values
        if ( new RegExp( this.options.type, 'i' ).test( 'number range' ) ) {
          this.options.type = 'number';

          // double condition to support jQuery and Zepto.. :(
          if ( 'undefined' !== typeof this.$element.attr( 'min' ) && this.$element.attr( 'min' ).length ) {
            this.options.min = this.$element.attr( 'min' );
          }

          if ( 'undefined' !== typeof this.$element.attr( 'max' ) && this.$element.attr( 'max' ).length ) {
            this.options.max = this.$element.attr( 'max' );
          }
        }
      }
    }

    /**
    * Attach field validators functions passed through data-api
    *
    * @private
    * @method addConstraints
    */
    , addConstraints: function () {
      for ( var constraint in this.options ) {
        constraint = constraint.toLowerCase();

        if ( 'function' === typeof this.Validator.validators[ constraint ] ) {
          this.constraints.push( {
              name: constraint
            , requirements: this.options[ constraint ]
            , isValid: null
          } );

          if ( constraint === 'required' ) {
            this.isRequired = true;
          }

          this.addCustomConstraintMessage( constraint );
        }
      }
    }

    /**
    * Add custom constraint message, passed through data-API
    *
    * @private
    * @method addCustomConstraintMessage
    * @param constraint
    */
    , addCustomConstraintMessage: function ( constraint ) {
      // custom message type data-type-email-message -> typeEmailMessage | data-minlength-error => minlengthMessage
      var customMessage = constraint
        + ( 'type' === constraint ? this.options[ constraint ].charAt( 0 ).toUpperCase() + this.options[ constraint ].substr( 1 ) : '' )
        + 'Message';

      if ( 'undefined' !== typeof this.options[ customMessage ] ) {
        this.Validator.addMessage( 'type' === constraint ? this.options[ constraint ] : constraint, this.options[ customMessage ], 'type' === constraint );
      }
    }

    /**
    * Bind validation events on a field
    *
    * @private
    * @method bindValidationEvents
    */
    , bindValidationEvents: function () {
      this.$element.addClass( 'parsley-validated' );

      // alaways bind keyup event, for better UX when a field is invalid
      var triggers = this.options.trigger + ( new RegExp( 'key', 'i' ).test( this.options.trigger ) ? '' : ' keyup' );

      // force add 'change' event if async remote validator here to have result before form submitting
      if ( this.options.remote ) {
        triggers += new RegExp( 'change', 'i' ).test( triggers ) ? '' : ' change';
      }

      // if a validation trigger is defined
      if ( triggers ) {
        this.$element.on( ( triggers + ' ').split( ' ' ).join( '.' + this.type + ' ' ), false, $.proxy( this.eventValidation, this ) );
      }
    }

    /**
    * Hash management. Used for ul error
    *
    * @method generateHash
    * @returns {String} 5 letters unique hash
    */
    , generateHash: function () {
      return 'parsley-' + ( Math.random() + '' ).substring( 2 );
    }

    /**
    * Public getHash accessor
    *
    * @method getHash
    * @returns {String} hash
    */
    , getHash: function () {
      return this.hash;
    }

    /**
    * Returns field val needed for validation
    * Special treatment for radio & checkboxes
    *
    * @method getVal
    * @returns {String} val
    */
    , getVal: function () {
      return this.$element.val();
    }

    /**
    * Called when validation is triggered by an event
    * Do nothing if val.length < this.options.validationMinlength
    *
    * @method eventValidation
    * @param {Object} event jQuery event
    */
    , eventValidation: function ( event ) {
      var val = this.getVal();

      // do nothing on keypress event if not explicitely passed as data-trigger and if field has not already been validated once
      if ( event.type === 'keyup' && !/keyup/i.test( this.options.trigger ) && !this.validatedOnce ) {
        return true;
      }

      // start validation process only if field has enough chars and validation never started
      if ( val.length < this.options.validationMinlength && !this.validatedOnce ) {
        return true;
      }

      this.validate( true, false );
    }

    /**
    * Return if field verify its constraints
    *
    * @method isValid
    * @return {Boolean} Is field valid or not
    */
    , isFieldValid: function () {
      return this.validate( false, false );
    }

    /**
    * Validate a field & display errors
    *
    * @method validate
    * @param {Boolean} errorBubbling set to false if you just want isValid boolean without error bubbling next to fields
    * @param {Boolean} async if false, wait ajax calls returns
    * @return {Boolean} Is field valid or not
    */
    , validate: function ( errorBubbling, async ) {
      var val = this.getVal()
        , isValid = null;

      // reset Parsley validation if onFieldValidate returns true, or if field is empty and not required
      if ( this.options.listeners.onFieldValidate( this.element, this ) || ( '' === val && !this.isRequired ) ) {
        this.reset();
        return null;
      }

      // do not validate a field already validated and unchanged !
      if ( !this.needsValidation( val ) ) {
        return this.isValid;
      }

      this.errorBubbling = 'undefined' !== typeof errorBubbling ? errorBubbling : true;
      this.async = 'undefined' !== typeof async ? async : true;

      isValid = this.applyValidators();

      if ( this.errorBubbling ) {
        this.manageValidationResult();
      }

      return isValid;
    }

    /**
    * Check if value has changed since previous validation
    *
    * @method needsValidation
    * @param value
    * @return {Boolean}
    */
    , needsValidation: function ( val ) {
      if ( this.isValid !== null && this.val === val && this.validatedOnce ) {
        return false;
      }

      this.val = val;
      return this.validatedOnce = true;
    }

    /**
    * Loop through every fields validators
    * Adds errors after unvalid fields
    *
    * @method applyValidators
    * @return {Mixed} {Boolean} If field valid or not, null if not validated
    */
    , applyValidators: function () {
      var isValid = null;

      for ( var constraint = 0; constraint < this.constraints.length; constraint++ ) {
        var result = this.Validator.validators[ this.constraints[ constraint ].name ]( this.val, this.constraints[ constraint ].requirements, this );

        if ( false === result ) {
          isValid = false;
          this.constraints[ constraint ].isValid = isValid;
        } else if ( true === result ) {
          this.constraints[ constraint ].isValid = true;
          isValid = false !== isValid;
        }
      }

      return isValid;
    }

    /**
    * Update a constraint state. Curently used by remote async validator
    *
    * @method updateConstraint
    * @param constraintName
    * @param property
    * @param value
    */
    , updateConstraint: function ( constraintName, property, value ) {
      for ( var i = 0; i < this.constraints.length; i++ ) {
        if ( this.constraints[ i ].name === constraintName ) {
          this.constraints[ i ][ property ] = value;
          break;
        }
      }
    }

    /**
    * Fired when all validators have be executed
    * Returns true or false if field is valid or not
    * Display errors messages below faild fields
    * Adds parsley-success or parsley-error class on fields
    *
    * @method manageValidationResult
    * @return {Boolean} Is field valid or not
    */
    , manageValidationResult: function () {
      var isValid = null;

      for ( var constraint = 0; constraint < this.constraints.length; constraint++ ) {
        if ( false === this.constraints[ constraint ].isValid ) {
          this.addError( this.constraints[ constraint ] );
          isValid = false;
        } else if ( true === this.constraints[ constraint ].isValid ) {
          this.removeError( this.constraints[ constraint ].name );
          isValid = false !== isValid;
        }
      }

      this.isValid = isValid;

      if ( true === this.isValid ) {
        this.removeErrors();
        this.errorClassHandler.removeClass( this.options.errorClass ).addClass( this.options.successClass );
        this.options.listeners.onFieldSuccess( this.element, this.constraints, this );
        return true;
      } else if ( false === this.isValid ) {
        this.errorClassHandler.removeClass( this.options.successClass ).addClass( this.options.errorClass );
        this.options.listeners.onFieldError( this.element, this.constraints, this );
        return false;
      }

      return isValid;
    }

    /**
    * Manage ul error Container
    *
    * @private
    * @method ulErrorManagement
    */
    , ulErrorManagement: function () {
      this.ulError = '#' + this.hash;
      this.ulTemplate = $( this.options.errors.errorsWrapper ).attr( 'id', this.hash ).addClass( 'parsley-error-list' );
    }

    /**
    * Remove li / ul error
    *
    * @method removeError
    * @param {String} constraintName Method Name
    */
    , removeError: function ( constraintName ) {
      var liError = this.ulError + ' .' + constraintName;

      // remove li error, and ul error if no more li inside
      if ( this.ulError && $( liError ).remove() && $( this.ulError ).children().length === 0 ) {
        $( this.ulError ).remove();
      }
    }

    /**
    * Remove all ul / li errors
    *
    * @method removeErrors
    */
    , removeErrors: function () {
      $( this.ulError ).remove();
    }

    /**
    * Remove ul errors and parsley error or success classes
    *
    * @method reset
    */
    , reset: function () {
      this.isValid = null;
      this.removeErrors();
      this.errorClassHandler.removeClass( this.options.successClass ).removeClass( this.options.errorClass );
      return this;
    }

    /**
    * Add li / ul errors messages
    *
    * @method addError
    * @param {Object} constraint
    */
    , addError: function ( constraint ) {

      // display ulError container if it has been removed previously (or never shown)
      if ( !$( this.ulError ).length ) {
        this.options.errors.container( this.element, this.ulTemplate, this.isRadioOrCheckbox )
          || ( !this.isRadioOrCheckbox ? this.$element.after( this.ulTemplate ) : this.$element.parent().after( this.ulTemplate ) );
      }

      // TODO: refacto error name w/ proper & readable function
      var constraintName = constraint.name
        , liClass = false !== this.options.errorMessage ? 'custom-error-message' : constraintName
        , liError = this.ulError + ' .' + liClass
        , liTemplate = $( this.options.errors.errorElem ).addClass( liClass )
        , message = false !== this.options.errorMessage ? this.options.errorMessage : ( constraint.name === 'type' ?
            this.Validator.messages[ constraintName ][ constraint.requirements ] : ( 'undefined' === typeof this.Validator.messages[ constraintName ] ?
              this.Validator.messages.defaultMessage : this.Validator.formatMesssage( this.Validator.messages[ constraintName ], constraint.requirements ) ) );

      // TODO: refacto this shit too
      // add liError if not shown. Do not add more than once custom errorMessage if exsit
      if ( !$( liError ).length ) {
        $( this.ulError ).append( $( liTemplate ).text( message ) );
      }
    }

    /**
    * Add custom listeners
    *
    * @param {Object} { listener: function () {} }, eg { onFormSubmit: function ( isValid, event, focus ) { ... } }
    */
    , addListener: function ( object ) {
      for ( var listener in object ) {
        this.options.listeners[ listener ] = object[ listener ];
      }
    }

    /**
    * Destroy parsley field instance
    *
    * @private
    * @method destroy
    */
    , destroy: function () {
      this.$element.removeClass( 'parsley-validated' );
      this.reset().$element.off( '.' + this.type ).removeData( this.type );
    }
  };

  /**
  * ParsleyFieldMultiple override ParsleyField for checkbox and radio inputs
  * Pseudo-heritance to manage divergent behavior from ParsleyItem in dedicated methods
  *
  * @class ParsleyFieldMultiple
  * @constructor
  */
  var ParsleyFieldMultiple = function ( element, options, type ) {
    this.initMultiple( element, options );
    this.inherit( element, options );
    this.Validator = new Validator( options );

    // call ParsleyField constructor
    this.init( element, type || 'ParsleyFieldMultiple' );
  };

  ParsleyFieldMultiple.prototype = {

    constructor: ParsleyFieldMultiple

    /**
    * Set some specific properties, call some extra methods to manage radio / checkbox
    *
    * @method init
    * @param {Object} element
    * @param {Object} options
    */
    , initMultiple: function ( element, options ) {
      this.element = element;
      this.$element = $( element );
      this.hash = this.getName();
      this.isRadioOrCheckbox = true;
      this.isRadio = this.$element.is( 'input[type=radio]' );
      this.isCheckbox = this.$element.is( 'input[type=checkbox]' );
      this.siblings = 'input[name="' + this.$element.attr( 'name' ) + '"]';
      this.$siblings = $( this.siblings );
      this.errorClassHandler = options.errors.classHandler( element ) || this.$element.parent();
    }

    /**
    * Set specific constraints messages, do pseudo-heritance
    *
    * @private
    * @method inherit
    * @param {Object} element
    * @param {Object} options
    */
    , inherit: function ( element, options ) {
      var clone = new ParsleyField( element, options );

      for ( var property in clone ) {
        if ( 'undefined' === typeof this[ property ] ) {
          this[ property ] = clone [ property ];
        }
      }
    }

    /**
    * Set specific constraints messages, do pseudo-heritance
    *
    * @method getName
    * @returns {String} radio / checkbox hash is cleaned 'name' property
    */
   , getName: function () {
     return 'parsley-' + this.$element.attr( 'name' ).replace( /(:|\.|\[|\])/g, '' );
   }

   /**
   * Special treatment for radio & checkboxes
   * Returns checked radio or checkboxes values
   *
   * @method getVal
   * @returns {String} val
   */
   , getVal: function () {
      if ( this.isRadio ) {
        return $( this.siblings + ':checked' ).val() || '';
      }

      if ( this.isCheckbox ) {
        var values = [];
        $( this.siblings + ':checked' ).each( function () {
          values.push( $( this ).val() );
        } );

        return values;
      }
   }
  };

  /**
  * ParsleyForm class manage Parsley validated form.
  * Manage its fields and global validation
  *
  * @class ParsleyForm
  * @constructor
  */
  var ParsleyForm = function ( element, options, type ) {
    this.init( element, options, type || 'parsleyForm' );
  };

  ParsleyForm.prototype = {

    constructor: ParsleyForm

    /* init data, bind jQuery on() actions */
    , init: function ( element, options, type ) {
      this.type = type;
      this.items = [];
      this.$element = $( element );
      this.options = options;
      var self = this
        , parsleyItem;

      this.$element.find( options.inputs ).each( function () {
        parsleyItem = $( this ).parsley( options );

        if ( null !== parsleyItem ) {
          self.items.push( parsleyItem );
        }
      });

      this.$element.on( 'submit.' + this.type , false, $.proxy( this.validate, this ) );
    }

    /**
    * Add custom listeners
    *
    * @param {Object} { listener: function () {} }, eg { onFormSubmit: function ( isValid, event, focus ) { ... } }
    */
    , addListener: function ( object ) {
      for ( var listener in object ) {
        if ( new RegExp( 'Field' ).test( listener ) ) {
          for ( var item = 0; item < this.items.length; item++ ) {
            this.items[ item ].addListener( object );
          }
        } else {
          this.options.listeners[ listener ] = object[ listener ];
        }
      }
    }

    /**
    * Process each form field validation
    * Display errors, call custom onFormSubmit() function
    *
    * @method validate
    * @param {Object} event jQuery Event
    * @return {Boolean} Is form valid or not
    */
    , validate: function ( event ) {
      var isValid = true;
      this.focusedField = false;

      for ( var item = 0; item < this.items.length; item++ ) {
        if ( false === this.items[ item ].validate() ) {
          isValid = false;

          if ( !this.focusedField && 'first' === this.options.focus || 'last' === this.options.focus ) {
            this.focusedField = this.items[ item ].$element;
          }
        }
      }

      // form is invalid, focus an error field depending on focus policy
      if ( this.focusedField && !isValid ) {
        this.focusedField.focus();
      }

      this.options.listeners.onFormSubmit( isValid, event, this );

      return isValid;
    }

    /**
    * Remove all errors ul under invalid fields
    *
    * @method removeErrors
    */
    , removeErrors: function () {
      for ( var item = 0; item < this.items.length; item++ ) {
        this.items[ item ].parsley( 'reset' );
      }
    }

    /**
    * destroy Parsley binded on the form and its fields
    *
    * @method destroy
    */
    , destroy: function () {
      for ( var item = 0; item < this.items.length; item++ ) {
        this.items[ item ].destroy();
      }

      this.$element.off( '.' + this.type ).removeData( this.type );
    }
  };

  /**
  * Parsley plugin definition
  * Provides an interface to access public Validator, ParsleyForm and ParsleyField functions
  *
  * @class Parsley
  * @constructor
  * @param {Mixed} Options. {Object} to configure Parsley or {String} method name to call a public class method
  * @param {Function} Callback function
  * @return {Mixed} public class method return
  */
  $.fn.parsley = function ( option, fn ) {
    var options = $.extend( true, {}, $.fn.parsley.defaults, 'undefined' !== typeof window.ParsleyConfig ? window.ParsleyConfig : {}, option, this.data() )
      , returnValue = null;

    function bind ( self, type ) {
      var parsleyInstance = $( self ).data( type );

      // if data never binded or we want to clone a build (for radio & checkboxes), bind it right now!
      if ( !parsleyInstance ) {
        switch ( type ) {
          case 'parsleyForm':
            parsleyInstance = new ParsleyForm( self, options, 'parsleyForm' );
            break;
          case 'parsleyField':
            parsleyInstance = new ParsleyField( self, options, 'parsleyField' );
            break;
          case 'parsleyFieldMultiple':
            parsleyInstance = new ParsleyFieldMultiple( self, options, 'parsleyFieldMultiple' );
            break;
          default:
            return;
        }

        $( self ).data( type, parsleyInstance );
      }

      // here is our parsley public function accessor
      if ( 'string' === typeof option && 'function' === typeof parsleyInstance[ option ] ) {
        return parsleyInstance[ option ]( fn );
      }

      return parsleyInstance;
    }

    // if a form elem is given, bind all its input children
    if ( $( this ).is( 'form' ) ) {
      returnValue = bind ( $( this ), 'parsleyForm' );

    // if it is a Parsley supported single element, bind it too, except inputs type hidden
    // add here a return instance, cuz' we could call public methods on single elems with data[ option ]() above
    } else if ( $( this ).is( options.inputs ) && !$( this ).is( options.excluded ) ) {
      returnValue = bind( $( this ), !$( this ).is( 'input[type=radio], input[type=checkbox]' ) ? 'parsleyField' : 'parsleyFieldMultiple' );
    }

    return 'function' === typeof fn ? fn() : returnValue;
  };

  $.fn.parsley.Constructor = ParsleyForm;

  /**
  * Parsley plugin configuration
  *
  * @property $.fn.parsley.defaults
  * @type {Object}
  */
  $.fn.parsley.defaults = {
    // basic data-api overridable properties here..
    inputs: 'input, textarea, select'           // Default supported inputs.
    , excluded: 'input[type=hidden], :disabled' // Do not validate input[type=hidden].
    , trigger: false                            // $.Event() that will trigger validation. eg: keyup, change..
    , focus: 'first'                            // 'fist'|'last'|'none' which error field would have focus first on form validation
    , validationMinlength: 3                    // If trigger validation specified, only if value.length > validationMinlength
    , successClass: 'parsley-success'           // Class name on each valid input
    , errorClass: 'parsley-error'               // Class name on each invalid input
    , errorMessage: false                       // Customize an unique error message showed if one constraint fails
    , validators: {}                            // Add your custom validators functions
    , messages: {}                              // Add your own error messages here

    //some quite advanced configuration here..
    , errors: {
        classHandler: function ( elem ) {}                                // class is directly set on elem, parent for radio/checkboxes
      , container: function ( elem, template, isRadioOrCheckbox ) {}      // error ul is inserted after elem, parent for radio/checkboxes
      , errorsWrapper: '<ul></ul>'                                        // do not set an id for this elem, it would have an auto-generated id
      , errorElem: '<li></li>'                                            // each field constraint fail in an li
      }
    , listeners: {
        onFieldValidate: function ( elem, ParsleyForm ) { return false; } // Executed on validation. Return true to ignore field validation
      , onFormSubmit: function ( isFormValid, event, ParsleyForm ) {}     // Executed once on form validation
      , onFieldError: function ( elem, constraints, ParsleyField ) {}     // Executed when a field is detected as invalid
      , onFieldSuccess: function ( elem, constraints, ParsleyField ) {}   // Executed when a field passes validation
    }
  };

  /* PARSLEY auto-bind DATA-API + Global config retrieving
  * =================================================== */
  $( window ).on( 'load', function () {
    $( '[data-validate="parsley"]' ).each( function () {
      $( this ).parsley();
    } );
  } );

// This plugin works with jQuery or Zepto (with data extension built for Zepto.)
}(window.jQuery || window.Zepto);

jQuery(function() {
  $.miniCount = function(element, options) {
    var addClass, formatText, hide, patterns, removeClass, setState, show, state,
      _this = this;
    this.defaults = {
      unit: 'character',
      min: null,
      max: null,
      countdown: false,
      hideOnValid: false,
      className: 'counter',
      validClassName: '',
      invalidClass: 'error',
      text: '',
      textPosition: 'after',
      invalidText: '',
      onValid: function() {},
      onInvalid: function() {}
    };
    state = '';
    patterns = {
      character: /./g,
      word: /\s|$/g,
      sentence: /(\S.+?[.!?])(?=\s+|$)/g
    };
    this.settings = {};
    this.$element = $(element);
    setState = function(_state) {
      if (_state === 'valid') {
        _this.callSettingFunction('onValid');
      } else if (_state === 'invalid') {
        _this.callSettingFunction('onInvalid');
      }
      return state = _state;
    };
    formatText = function(_text) {
      if (_text == null) {
        _text = '';
      }
      if (_this.getSetting('textPosition') === 'before') {
        return _text + ' ';
      } else {
        return ' ' + _text;
      }
    };
    addClass = function(_class) {
      _this.$element.addClass(_class);
      return _this.$counterWrapper.addClass(_class);
    };
    removeClass = function(_class) {
      _this.$element.removeClass(_class);
      return _this.$counterWrapper.removeClass(_class);
    };
    show = function() {
      _this.$counter.css('visibility', 'visible');
      return _this.$text.css('visibility', 'visible');
    };
    hide = function() {
      _this.$counter.css('visibility', 'hidden');
      return _this.$text.css('visibility', 'hidden');
    };
    this.getState = function() {
      return state;
    };
    this.getSetting = function(settingKey) {
      return this.settings[settingKey];
    };
    this.callSettingFunction = function(functionName) {
      return this.settings[functionName](element, this.$counter[0], this.count());
    };
    this.count = function() {
      if (_this.$element.val().length > 0) {
        return _this.$element.val().match(patterns[_this.getSetting('unit')]).length;
      } else {
        return 0;
      }
    };
    this.updateCounter = function() {
      var _diff, _error;
      _diff = _this.count();
      _error = false;
      if (_this.getSetting('min') != null) {
        if (_this.getSetting('min') > _diff || ((_this.getSetting('max') != null) && _this.getSetting('max') < _diff)) {
          _error = true;
        }
        if (_this.getSetting('countdown') && !(_this.getSetting('max') != null)) {
          _diff = _this.count() - _this.getSetting('min');
        }
      } else if (_this.getSetting('max') != null) {
        if (_this.getSetting('max') < _diff) {
          _error = true;
        }
        if (_this.getSetting('countdown')) {
          _diff = _this.getSetting('max') - _this.count();
        }
      }
      if (_error || _diff < 0) {
        if (_this.getState() !== 'invalid') {
          if (_this.getSetting('hideOnValid')) {
            show();
          }
          if (_this.getSetting('invalidClass') != null) {
            addClass(_this.getSetting('invalidClass'));
          }
          if (_this.getSetting('validClass') != null) {
            removeClass(_this.getSetting('validClass'));
          }
          _this.$text.text(formatText(_this.getSetting('invalidText')));
          setState('invalid');
        }
      } else {
        if (_this.getState() !== 'valid') {
          if (_this.getSetting('hideOnValid')) {
            hide();
          }
          if (_this.getSetting('invalidClass') != null) {
            removeClass(_this.getSetting('invalidClass'));
          }
          if (_this.getSetting('validClass') != null) {
            addClass(_this.getSetting('validClass'));
          }
          _this.$text.text(formatText(_this.getSetting('text')));
        }
        setState('valid');
      }
      return _this.$counter.text(_diff);
    };
    this.init = function() {
      var invalidText, text;
      this.settings = $.extend({}, this.defaults, options);
      if (!(this.getSetting('unit').match('character|word|sentence') != null)) {
        return this.$element;
      }
      text = this.getSetting('text').length ? this.getSetting('text') : this.getSetting('unit');
      invalidText = this.getSetting('invalidText').length ? this.getSetting('invalidText') : this.getSetting('unit');
      this.$counter = $('<span />');
      this.$text = $('<span />');
      this.$counterWrapper = $('<div />', {
        'class': this.getSetting('className'),
        'css': {
          'display': 'none'
        }
      }).append(this.$text);
      if (this.getSetting('textPosition') === 'before') {
        this.$counterWrapper.append(this.$counter);
      } else {
        this.$counterWrapper.prepend(this.$counter);
      }
      this.$element.before(this.$counterWrapper);
      this.updateCounter();
      this.$counterWrapper.show();
      return this.$element.bind('click focus keyup blur change paste', this.updateCounter);
    };
    this.init();
    return this;
  };
  return $.fn.miniCount = function(options) {
    return this.each(function() {
      var miniCount;
      if (void 0 === ($(this)).data('miniCount')) {
        miniCount = new $.miniCount(this, options);
        return ($(this)).data('miniCount', miniCount);
      }
    });
  };
});
/* ===================================================
 * bootstrap-transition.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#transitions
 * ===================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function ($) {

  $(function () {

    "use strict"; // jshint ;_;


    /* CSS TRANSITION SUPPORT (http://www.modernizr.com/)
     * ======================================================= */

    $.support.transition = (function () {

      var transitionEnd = (function () {

        var el = document.createElement('bootstrap')
          , transEndEventNames = {
               'WebkitTransition' : 'webkitTransitionEnd'
            ,  'MozTransition'    : 'transitionend'
            ,  'OTransition'      : 'oTransitionEnd otransitionend'
            ,  'transition'       : 'transitionend'
            }
          , name

        for (name in transEndEventNames){
          if (el.style[name] !== undefined) {
            return transEndEventNames[name]
          }
        }

      }())

      return transitionEnd && {
        end: transitionEnd
      }

    })()

  })

}(window.jQuery);
/* ============================================================
 * bootstrap-button.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#buttons
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function ($) {

  "use strict"; // jshint ;_;


 /* BUTTON PUBLIC CLASS DEFINITION
  * ============================== */

  var Button = function (element, options) {
    this.$element = $(element)
    this.options = $.extend({}, $.fn.button.defaults, options)
  }

  Button.prototype.setState = function (state) {
    var d = 'disabled'
      , $el = this.$element
      , data = $el.data()
      , val = $el.is('input') ? 'val' : 'html'

    state = state + 'Text'
    data.resetText || $el.data('resetText', $el[val]())

    $el[val](data[state] || this.options[state])

    // push to event loop to allow forms to submit
    setTimeout(function () {
      state == 'loadingText' ?
        $el.addClass(d).attr(d, d) :
        $el.removeClass(d).removeAttr(d)
    }, 0)
  }

  Button.prototype.toggle = function () {
    var $parent = this.$element.closest('[data-toggle="buttons-radio"]')

    $parent && $parent
      .find('.active')
      .removeClass('active')

    this.$element.toggleClass('active')
  }


 /* BUTTON PLUGIN DEFINITION
  * ======================== */

  $.fn.button = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('button')
        , options = typeof option == 'object' && option
      if (!data) $this.data('button', (data = new Button(this, options)))
      if (option == 'toggle') data.toggle()
      else if (option) data.setState(option)
    })
  }

  $.fn.button.defaults = {
    loadingText: 'loading...'
  }

  $.fn.button.Constructor = Button


 /* BUTTON DATA-API
  * =============== */

  $(function () {
    $('body').on('click.button.data-api', '[data-toggle^=button]', function ( e ) {
      var $btn = $(e.target)
      if (!$btn.hasClass('btn')) $btn = $btn.closest('.btn')
      $btn.button('toggle')
    })
  })

}(window.jQuery);
/* ========================================================
 * bootstrap-tab.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#tabs
 * ========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ======================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* TAB CLASS DEFINITION
  * ==================== */

  var Tab = function (element) {
    this.element = $(element)
  }

  Tab.prototype = {

    constructor: Tab

  , show: function () {
      var $this = this.element
        , $ul = $this.closest('ul:not(.dropdown-menu)')
        , selector = $this.attr('data-target')
        , previous
        , $target
        , e

      if (!selector) {
        selector = $this.attr('href')
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
      }

      if ( $this.parent('li').hasClass('active') ) return

      previous = $ul.find('.active a').last()[0]

      e = $.Event('show', {
        relatedTarget: previous
      })

      $this.trigger(e)

      if (e.isDefaultPrevented()) return

      $target = $(selector)

      this.activate($this.parent('li'), $ul)
      this.activate($target, $target.parent(), function () {
        $this.trigger({
          type: 'shown'
        , relatedTarget: previous
        })
      })
    }

  , activate: function ( element, container, callback) {
      var $active = container.find('> .active')
        , transition = callback
            && $.support.transition
            && $active.hasClass('fade')

      function next() {
        $active
          .removeClass('active')
          .find('> .dropdown-menu > .active')
          .removeClass('active')

        element.addClass('active')

        if (transition) {
          element[0].offsetWidth // reflow for transition
          element.addClass('in')
        } else {
          element.removeClass('fade')
        }

        if ( element.parent('.dropdown-menu') ) {
          element.closest('li.dropdown').addClass('active')
        }

        callback && callback()
      }

      transition ?
        $active.one($.support.transition.end, next) :
        next()

      $active.removeClass('in')
    }
  }


 /* TAB PLUGIN DEFINITION
  * ===================== */

  $.fn.tab = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tab')
      if (!data) $this.data('tab', (data = new Tab(this)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.tab.Constructor = Tab


 /* TAB DATA-API
  * ============ */

  $(function () {
    $('body').on('click.tab.data-api', '[data-toggle="tab"], [data-toggle="pill"]', function (e) {
      e.preventDefault()
      $(this).tab('show')
    })
  })

}(window.jQuery);
/* ============================================================
 * bootstrap-dropdown.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function ($) {

  "use strict"; // jshint ;_;


 /* DROPDOWN CLASS DEFINITION
  * ========================= */

  var toggle = '[data-toggle=dropdown]'
    , Dropdown = function (element) {
        var $el = $(element).on('click.dropdown.data-api', this.toggle)
        $('html').on('click.dropdown.data-api', function () {
          $el.parent().removeClass('open')
        })
      }

  Dropdown.prototype = {

    constructor: Dropdown

  , toggle: function (e) {
      var $this = $(this)
        , $parent
        , isActive

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      clearMenus()

      if (!isActive) {
        $parent.toggleClass('open')
        $this.focus()
      }

      return false
    }

  , keydown: function (e) {
      var $this
        , $items
        , $active
        , $parent
        , isActive
        , index

      if (!/(38|40|27)/.test(e.keyCode)) return

      $this = $(this)

      e.preventDefault()
      e.stopPropagation()

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      if (!isActive || (isActive && e.keyCode == 27)) return $this.click()

      $items = $('[role=menu] li:not(.divider) a', $parent)

      if (!$items.length) return

      index = $items.index($items.filter(':focus'))

      if (e.keyCode == 38 && index > 0) index--                                        // up
      if (e.keyCode == 40 && index < $items.length - 1) index++                        // down
      if (!~index) index = 0

      $items
        .eq(index)
        .focus()
    }

  }

  function clearMenus() {
    $(toggle).each(function () {
      getParent($(this)).removeClass('open')
    })
  }

  function getParent($this) {
    var selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = $(selector)
    $parent.length || ($parent = $this.parent())

    return $parent
  }


  /* DROPDOWN PLUGIN DEFINITION
   * ========================== */

  $.fn.dropdown = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('dropdown')
      if (!data) $this.data('dropdown', (data = new Dropdown(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  $.fn.dropdown.Constructor = Dropdown


  /* APPLY TO STANDARD DROPDOWN ELEMENTS
   * =================================== */

  $(function () {
    $('html')
      .on('click.dropdown.data-api touchstart.dropdown.data-api', clearMenus)
    $('body')
      .on('click.dropdown touchstart.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() })
      .on('click.dropdown.data-api touchstart.dropdown.data-api'  , toggle, Dropdown.prototype.toggle)
      .on('keydown.dropdown.data-api touchstart.dropdown.data-api', toggle + ', [role=menu]' , Dropdown.prototype.keydown)
  })

}(window.jQuery);
/* =============================================================
 * bootstrap-collapse.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#collapse
 * =============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */


!function ($) {

  "use strict"; // jshint ;_;


 /* COLLAPSE PUBLIC CLASS DEFINITION
  * ================================ */

  var Collapse = function (element, options) {
    this.$element = $(element)
    this.options = $.extend({}, $.fn.collapse.defaults, options)

    if (this.options.parent) {
      this.$parent = $(this.options.parent)
    }

    this.options.toggle && this.toggle()
  }

  Collapse.prototype = {

    constructor: Collapse

  , dimension: function () {
      var hasWidth = this.$element.hasClass('width')
      return hasWidth ? 'width' : 'height'
    }

  , show: function () {
      var dimension
        , scroll
        , actives
        , hasData

      if (this.transitioning) return

      dimension = this.dimension()
      scroll = $.camelCase(['scroll', dimension].join('-'))
      actives = this.$parent && this.$parent.find('> .accordion-group > .in')

      if (actives && actives.length) {
        hasData = actives.data('collapse')
        if (hasData && hasData.transitioning) return
        actives.collapse('hide')
        hasData || actives.data('collapse', null)
      }

      this.$element[dimension](0)
      this.transition('addClass', $.Event('show'), 'shown')
      $.support.transition && this.$element[dimension](this.$element[0][scroll])
    }

  , hide: function () {
      var dimension
      if (this.transitioning) return
      dimension = this.dimension()
      this.reset(this.$element[dimension]())
      this.transition('removeClass', $.Event('hide'), 'hidden')
      this.$element[dimension](0)
    }

  , reset: function (size) {
      var dimension = this.dimension()

      this.$element
        .removeClass('collapse')
        [dimension](size || 'auto')
        [0].offsetWidth

      this.$element[size !== null ? 'addClass' : 'removeClass']('collapse')

      return this
    }

  , transition: function (method, startEvent, completeEvent) {
      var that = this
        , complete = function () {
            if (startEvent.type == 'show') that.reset()
            that.transitioning = 0
            that.$element.trigger(completeEvent)
          }

      this.$element.trigger(startEvent)

      if (startEvent.isDefaultPrevented()) return

      this.transitioning = 1

      this.$element[method]('in')
      // EthilVan start
      var trigger = $('[data-toggle=collapse][href="#' + this.$element.attr('id') + '"]');
      trigger[method == 'removeClass' ? 'addClass' : 'removeClass']('collapsed');
      // EthilVan end

      $.support.transition && this.$element.hasClass('collapse') ?
        this.$element.one($.support.transition.end, complete) :
        complete()
    }

  , toggle: function () {
      this[this.$element.hasClass('in') ? 'hide' : 'show']()
    }

  }


 /* COLLAPSIBLE PLUGIN DEFINITION
  * ============================== */

  $.fn.collapse = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('collapse')
        , options = typeof option == 'object' && option
      if (!data) $this.data('collapse', (data = new Collapse(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.collapse.defaults = {
    toggle: true
  }

  $.fn.collapse.Constructor = Collapse


 /* COLLAPSIBLE DATA-API
  * ==================== */

  $(function () {
    $('body').on('click.collapse.data-api', '[data-toggle=collapse]', function (e) {
      var $this = $(this), href
        , target = $this.attr('data-target')
          || e.preventDefault()
          || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') //strip for ie7
        , option = $(target).data('collapse') ? 'toggle' : $this.data()
      // EthilVan start
      //$this[$(target).hasClass('in') ? 'addClass' : 'removeClass']('collapsed')
      // EthilVan end
      $(target).collapse(option)
    })
  })

}(window.jQuery);
/* ==========================================================
 * bootstrap-carousel.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#carousel
 * ==========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================== */


!function ($) {

  "use strict"; // jshint ;_;


 /* CAROUSEL CLASS DEFINITION
  * ========================= */

  var Carousel = function (element, options) {
    this.$element = $(element)
    this.options = options
    this.options.slide && this.slide(this.options.slide)
    this.options.pause == 'hover' && this.$element
      .on('mouseenter', $.proxy(this.pause, this))
      .on('mouseleave', $.proxy(this.cycle, this))
  }

  Carousel.prototype = {

    cycle: function (e) {
      if (!e) this.paused = false
      this.options.interval
        && !this.paused
        && (this.interval = setInterval($.proxy(this.next, this), this.options.interval))
      return this
    }

  , to: function (pos) {
      var $active = this.$element.find('.item.active')
        , children = $active.parent().children()
        , activePos = children.index($active)
        , that = this

      if (pos > (children.length - 1) || pos < 0) return

      if (this.sliding) {
        return this.$element.one('slid', function () {
          that.to(pos)
        })
      }

      if (activePos == pos) {
        return this.pause().cycle()
      }

      return this.slide(pos > activePos ? 'next' : 'prev', $(children[pos]))
    }

  , pause: function (e) {
      if (!e) this.paused = true
      if (this.$element.find('.next, .prev').length && $.support.transition.end) {
        this.$element.trigger($.support.transition.end)
        this.cycle()
      }
      clearInterval(this.interval)
      this.interval = null
      return this
    }

  , next: function () {
      if (this.sliding) return
      return this.slide('next')
    }

  , prev: function () {
      if (this.sliding) return
      return this.slide('prev')
    }

  , slide: function (type, next) {
      var $active = this.$element.find('.item.active')
        , $next = next || $active[type]()
        , isCycling = this.interval
        , direction = type == 'next' ? 'left' : 'right'
        , fallback  = type == 'next' ? 'first' : 'last'
        , that = this
        , e = $.Event('slide', {
            relatedTarget: $next[0]
          })

      this.sliding = true

      isCycling && this.pause()

      $next = $next.length ? $next : this.$element.find('.item')[fallback]()

      if ($next.hasClass('active')) return

      if ($.support.transition && this.$element.hasClass('slide')) {
        this.$element.trigger(e)
        if (e.isDefaultPrevented()) return
        $next.addClass(type)
        $next[0].offsetWidth // force reflow
        $active.addClass(direction)
        $next.addClass(direction)
        this.$element.one($.support.transition.end, function () {
          $next.removeClass([type, direction].join(' ')).addClass('active')
          $active.removeClass(['active', direction].join(' '))
          that.sliding = false
          setTimeout(function () { that.$element.trigger('slid') }, 0)
        })
      } else {
        this.$element.trigger(e)
        if (e.isDefaultPrevented()) return
        $active.removeClass('active')
        $next.addClass('active')
        this.sliding = false
        this.$element.trigger('slid')
      }

      isCycling && this.cycle()

      return this
    }

  }


 /* CAROUSEL PLUGIN DEFINITION
  * ========================== */

  $.fn.carousel = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('carousel')
        , options = $.extend({}, $.fn.carousel.defaults, typeof option == 'object' && option)
        , action = typeof option == 'string' ? option : options.slide
      if (!data) $this.data('carousel', (data = new Carousel(this, options)))
      if (typeof option == 'number') data.to(option)
      else if (action) data[action]()
      else if (options.interval) data.cycle()
    })
  }

  $.fn.carousel.defaults = {
    interval: 5000
  , pause: 'hover'
  }

  $.fn.carousel.Constructor = Carousel


 /* CAROUSEL DATA-API
  * ================= */

  $(function () {
    $('body').on('click.carousel.data-api', '[data-slide]', function ( e ) {
      var $this = $(this), href
        , $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
        , options = !$target.data('modal') && $.extend({}, $target.data(), $this.data())
      $target.carousel(options)
      e.preventDefault()
    })
  })

}(window.jQuery);
/* =========================================================
 * bootstrap-modal.js v2.1.1
 * http://twitter.github.com/bootstrap/javascript.html#modals
 * =========================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */


!function ($) {

  "use strict"; // jshint ;_;


 /* MODAL CLASS DEFINITION
  * ====================== */

  var Modal = function (element, options) {
    this.options = options
    this.$element = $(element)
      .delegate('[data-dismiss="modal"]', 'click.dismiss.modal', $.proxy(this.hide, this))
    this.options.remote && this.$element.find('.modal-body').load(this.options.remote)
  }

  Modal.prototype = {

      constructor: Modal

    , toggle: function () {
        return this[!this.isShown ? 'show' : 'hide']()
      }

    , show: function () {
        var that = this
          , e = $.Event('show')

        this.$element.trigger(e)

        if (this.isShown || e.isDefaultPrevented()) return

        $('body').addClass('modal-open')

        this.isShown = true

        this.escape()

        this.backdrop(function () {
          var transition = $.support.transition && that.$element.hasClass('fade')

          if (!that.$element.parent().length) {
            that.$element.appendTo(document.body) //don't move modals dom position
          }

          that.$element
            .show()

          if (transition) {
            that.$element[0].offsetWidth // force reflow
          }

          that.$element
            .addClass('in')
            .attr('aria-hidden', false)
            .focus()

          that.enforceFocus()

          transition ?
            that.$element.one($.support.transition.end, function () { that.$element.trigger('shown') }) :
            that.$element.trigger('shown')

        })
      }

    , hide: function (e) {
        e && e.preventDefault()

        var that = this

        e = $.Event('hide')

        this.$element.trigger(e)

        if (!this.isShown || e.isDefaultPrevented()) return

        this.isShown = false

        $('body').removeClass('modal-open')

        this.escape()

        $(document).off('focusin.modal')

        this.$element
          .removeClass('in')
          .attr('aria-hidden', true)

        $.support.transition && this.$element.hasClass('fade') ?
          this.hideWithTransition() :
          this.hideModal()
      }

    , enforceFocus: function () {
        var that = this
        $(document).on('focusin.modal', function (e) {
          if (that.$element[0] !== e.target && !that.$element.has(e.target).length) {
            that.$element.focus()
          }
        })
      }

    , escape: function () {
        var that = this
        if (this.isShown && this.options.keyboard) {
          this.$element.on('keyup.dismiss.modal', function ( e ) {
            e.which == 27 && that.hide()
          })
        } else if (!this.isShown) {
          this.$element.off('keyup.dismiss.modal')
        }
      }

    , hideWithTransition: function () {
        var that = this
          , timeout = setTimeout(function () {
              that.$element.off($.support.transition.end)
              that.hideModal()
            }, 500)

        this.$element.one($.support.transition.end, function () {
          clearTimeout(timeout)
          that.hideModal()
        })
      }

    , hideModal: function (that) {
        this.$element
          .hide()
          .trigger('hidden')

        this.backdrop()
      }

    , removeBackdrop: function () {
        this.$backdrop.remove()
        this.$backdrop = null
      }

    , backdrop: function (callback) {
        var that = this
          , animate = this.$element.hasClass('fade') ? 'fade' : ''

        if (this.isShown && this.options.backdrop) {
          var doAnimate = $.support.transition && animate

          this.$backdrop = $('<div class="modal-backdrop ' + animate + '" />')
            .appendTo(document.body)

          if (this.options.backdrop != 'static') {
            this.$backdrop.click($.proxy(this.hide, this))
          }

          if (doAnimate) this.$backdrop[0].offsetWidth // force reflow

          this.$backdrop.addClass('in')

          doAnimate ?
            this.$backdrop.one($.support.transition.end, callback) :
            callback()

        } else if (!this.isShown && this.$backdrop) {
          this.$backdrop.removeClass('in')

          $.support.transition && this.$element.hasClass('fade')?
            this.$backdrop.one($.support.transition.end, $.proxy(this.removeBackdrop, this)) :
            this.removeBackdrop()

        } else if (callback) {
          callback()
        }
      }
  }


 /* MODAL PLUGIN DEFINITION
  * ======================= */

  $.fn.modal = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('modal')
        , options = $.extend({}, $.fn.modal.defaults, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option]()
      else if (options.show) data.show()
    })
  }

  $.fn.modal.defaults = {
      backdrop: true
    , keyboard: true
    , show: true
  }

  $.fn.modal.Constructor = Modal


 /* MODAL DATA-API
  * ============== */

  $(function () {
    $('body').on('click.modal.data-api', '[data-toggle="modal"]', function ( e ) {
      var $this = $(this)
        , href = $this.attr('href')
        , $target = $($this.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, ''))) //strip for ie7
        , option = $target.data('modal') ? 'toggle' : $.extend({ remote: !/#/.test(href) && href }, $target.data(), $this.data())

      e.preventDefault()

      $target
        .modal(option)
        .one('hide', function () {
          $this.focus()
        })
    })
  })

}(window.jQuery);
/**
 * bootbox.js v3.0.0
 *
 * http://bootboxjs.com/license.txt
 */
var bootbox = window.bootbox || (function(document, $) {

    var _locale        = 'en',
        _defaultLocale = 'en',
        _animate       = true,
        _backdrop      = 'static',
        _defaultHref   = 'javascript:;',
        _classes       = '',
        _icons         = {},
        /* last var should always be the public object we'll return */
        that           = {};


    /**
     * public API
     */
    that.setLocale = function(locale) {
        for (var i in _locales) {
            if (i == locale) {
                _locale = locale;
                return;
            }
        }
        throw new Error('Invalid locale: '+locale);
    };

    that.addLocale = function(locale, translations) {
        if (typeof _locales[locale] === 'undefined') {
            _locales[locale] = {};
        }
        for (var str in translations) {
            _locales[locale][str] = translations[str];
        }
    };

    that.setIcons = function(icons) {
        _icons = icons;
        if (typeof _icons !== 'object' || _icons == null) {
            _icons = {};
        }
    };

    that.alert = function(/*str, label, cb*/) {
        var str   = "",
            label = _translate('OK'),
            cb    = null;

        switch (arguments.length) {
            case 1:
                // no callback, default button label
                str = arguments[0];
                break;
            case 2:
                // callback *or* custom button label dependent on type
                str = arguments[0];
                if (typeof arguments[1] == 'function') {
                    cb = arguments[1];
                } else {
                    label = arguments[1];
                }
                break;
            case 3:
                // callback and custom button label
                str   = arguments[0];
                label = arguments[1];
                cb    = arguments[2];
                break;
            default:
                throw new Error("Incorrect number of arguments: expected 1-3");
                break;
        }

        return that.dialog(str, {
            // only button (ok)
            "label"   : label,
            "icon"    : _icons.OK,
            "callback": cb
        }, {
            // ensure that the escape key works; either invoking the user's
            // callback or true to just close the dialog
            "onEscape": cb || true
        });
    };

    that.confirm = function(/*str, labelCancel, labelOk, cb*/) {
        var str         = "",
            labelCancel = _translate('CANCEL'),
            labelOk     = _translate('CONFIRM'),
            cb          = null;

        switch (arguments.length) {
            case 1:
                str = arguments[0];
                break;
            case 2:
                str = arguments[0];
                if (typeof arguments[1] == 'function') {
                    cb = arguments[1];
                } else {
                    labelCancel = arguments[1];
                }
                break;
            case 3:
                str         = arguments[0];
                labelCancel = arguments[1];
                if (typeof arguments[2] == 'function') {
                    cb = arguments[2];
                } else {
                    labelOk = arguments[2];
                }
                break;
            case 4:
                str         = arguments[0];
                labelCancel = arguments[1];
                labelOk     = arguments[2];
                cb          = arguments[3];
                break;
            default:
                throw new Error("Incorrect number of arguments: expected 1-4");
                break;
        }

        var cancelCallback = function() {
            if (typeof cb === 'function') {
                cb(false);
            }
        };

        var confirmCallback = function() {
            if (typeof cb === 'function') {
                cb(true);
            }
        };

        return that.dialog(str, [{
            // first button (cancel)
            "label"   : labelCancel,
            "icon"    : _icons.CANCEL,
            "callback": cancelCallback
        }, {
            // second button (confirm)
            "label"   : labelOk,
            "icon"    : _icons.CONFIRM,
            "callback": confirmCallback
        }], {
            // escape key bindings
            "onEscape": cancelCallback
        });
    };

    that.prompt = function(/*str, labelCancel, labelOk, cb, defaultVal*/) {
        var str         = "",
            labelCancel = _translate('CANCEL'),
            labelOk     = _translate('CONFIRM'),
            cb          = null,
            defaultVal  = "";

        switch (arguments.length) {
            case 1:
                str = arguments[0];
                break;
            case 2:
                str = arguments[0];
                if (typeof arguments[1] == 'function') {
                    cb = arguments[1];
                } else {
                    labelCancel = arguments[1];
                }
                break;
            case 3:
                str         = arguments[0];
                labelCancel = arguments[1];
                if (typeof arguments[2] == 'function') {
                    cb = arguments[2];
                } else {
                    labelOk = arguments[2];
                }
                break;
            case 4:
                str         = arguments[0];
                labelCancel = arguments[1];
                labelOk     = arguments[2];
                cb          = arguments[3];
                break;
            case 5:
                str         = arguments[0];
                labelCancel = arguments[1];
                labelOk     = arguments[2];
                cb          = arguments[3];
                defaultVal  = arguments[4];
                break;
            default:
                throw new Error("Incorrect number of arguments: expected 1-5");
                break;
        }

        var header = str;

        // let's keep a reference to the form object for later
        var form = $("<form></form>");
        form.append("<input autocomplete=off type=text value='" + defaultVal + "' />");

        var cancelCallback = function() {
            if (typeof cb === 'function') {
                // yep, native prompts dismiss with null, whereas native
                // confirms dismiss with false...
                cb(null);
            }
        };

        var confirmCallback = function() {
            if (typeof cb === 'function') {
                cb(form.find("input[type=text]").val());
            }
        };

        var div = that.dialog(form, [{
            // first button (cancel)
            "label"   : labelCancel,
            "icon"    : _icons.CANCEL,
            "callback":  cancelCallback
        }, {
            // second button (confirm)
            "label"   : labelOk,
            "icon"    : _icons.CONFIRM,
            "callback": confirmCallback
        }], {
            // prompts need a few extra options
            "header"  : header,
            // explicitly tell dialog NOT to show the dialog...
            "show"    : false,
            "onEscape": cancelCallback
        });

        // ... the reason the prompt needs to be hidden is because we need
        // to bind our own "shown" handler, after creating the modal but
        // before any show(n) events are triggered
        // @see https://github.com/makeusabrew/bootbox/issues/69

        div.on("shown", function() {
            form.find("input[type=text]").focus();

            // ensure that submitting the form (e.g. with the enter key)
            // replicates the behaviour of a normal prompt()
            form.on("submit", function(e) {
                e.preventDefault();
                div.find(".btn-primary").click();
            });
        });

        div.modal("show");

        return div;
    };

    that.dialog = function(str, handlers, options) {
        var buttons    = "",
            callbacks  = [],
            options    = options || {};

        // check for single object and convert to array if necessary
        if (handlers == null) {
            handlers = [];
        } else if (typeof handlers.length == 'undefined') {
            handlers = [handlers];
        }

        var i = handlers.length;
        while (i--) {
            var label    = null,
                href     = null,
                _class   = null,
                icon     = '',
                callback = null;

            if (typeof handlers[i]['label']    == 'undefined' &&
                typeof handlers[i]['class']    == 'undefined' &&
                typeof handlers[i]['callback'] == 'undefined') {
                // if we've got nothing we expect, check for condensed format

                var propCount = 0,      // condensed will only match if this == 1
                    property  = null;   // save the last property we found

                // be nicer to count the properties without this, but don't think it's possible...
                for (var j in handlers[i]) {
                    property = j;
                    if (++propCount > 1) {
                        // forget it, too many properties
                        break;
                    }
                }

                if (propCount == 1 && typeof handlers[i][j] == 'function') {
                    // matches condensed format of label -> function
                    handlers[i]['label']    = property;
                    handlers[i]['callback'] = handlers[i][j];
                }
            }

            if (typeof handlers[i]['callback']== 'function') {
                callback = handlers[i]['callback'];
            }

            if (handlers[i]['class']) {
                _class = handlers[i]['class'];
            } else if (i == handlers.length -1 && handlers.length <= 2) {
                // always add a primary to the main option in a two-button dialog
                _class = 'btn-primary';
            }

            if (handlers[i]['label']) {
                label = handlers[i]['label'];
            } else {
                label = "Option "+(i+1);
            }

            if (handlers[i]['icon']) {
                icon = "<i class='"+handlers[i]['icon']+"'></i> ";
            }

            if (handlers[i]['href']) {
                href = handlers[i]['href'];
            }
            else {
                href = _defaultHref;
            }

            buttons = "<a data-handler='"+i+"' class='btn "+_class+"' href='" + href + "'>"+icon+""+label+"</a>" + buttons;

            callbacks[i] = callback;
        }

        // @see https://github.com/makeusabrew/bootbox/issues/46#issuecomment-8235302
        // and https://github.com/twitter/bootstrap/issues/4474
        // for an explanation of the inline overflow: hidden
        // @see https://github.com/twitter/bootstrap/issues/4854
        // for an explanation of tabIndex=-1

        var parts = ["<div class='bootbox modal' tabindex='-1' style='overflow:hidden;'>"];

        if (options['header']) {
            var closeButton = '';
            if (typeof options['headerCloseButton'] == 'undefined' || options['headerCloseButton']) {
                closeButton = "<a href='"+_defaultHref+"' class='close'>&times;</a>";
            }

            parts.push("<div class='modal-header'>"+closeButton+"<h3>"+options['header']+"</h3></div>");
        }

        // push an empty body into which we'll inject the proper content later
        parts.push("<div class='modal-body'></div>");

        if (buttons) {
            parts.push("<div class='modal-footer'>"+buttons+"</div>");
        }

        parts.push("</div>");

        var div = $(parts.join("\n"));

        // check whether we should fade in/out
        var shouldFade = (typeof options.animate === 'undefined') ? _animate : options.animate;

        if (shouldFade) {
            div.addClass("fade");
        }

        var optionalClasses = (typeof options.classes === 'undefined') ? _classes : options.classes;
        if (optionalClasses) {
            div.addClass(optionalClasses);
        }

        // now we've built up the div properly we can inject the content whether it was a string or a jQuery object
        div.find(".modal-body").html(str);

        div.on('hidden', function() {
            div.remove();
        });

        // hook into the modal's keyup trigger to check for the escape key
        div.on('keyup.dismiss.modal', function(e) {
            // any truthy value passed to onEscape will dismiss the dialog...
            if (e.which == 27 && options.onEscape) {
                if (typeof options.onEscape === 'function') {
                    // ... but only a function will be invoked (obviously)
                    options.onEscape();
                }

                div.modal('hide');
            }
        });

        // well, *if* we have a primary - give the first dom element focus
        div.on('shown', function() {
            div.find("a.btn-primary:first").focus();
        });

        // wire up button handlers
        div.on('click', '.modal-footer a, a.close', function(e) {

            var handler   = $(this).data("handler"),
                cb        = callbacks[handler],
                hideModal = null;

            // sort of @see https://github.com/makeusabrew/bootbox/pull/68 - heavily adapted
            // if we've got a custom href attribute, all bets are off
            if (typeof handler                   !== 'undefined' &&
                typeof handlers[handler]['href'] !== 'undefined') {

                return;
            }

            e.preventDefault();

            if (typeof cb == 'function') {
                hideModal = cb();
            }

            // the only way hideModal *will* be false is if a callback exists and
            // returns it as a value. in those situations, don't hide the dialog
            // @see https://github.com/makeusabrew/bootbox/pull/25
            if (hideModal !== false) {
                div.modal("hide");
            }
        });

        // stick the modal right at the bottom of the main body out of the way
        $("body").append(div);

        div.modal({
            // unless explicitly overridden take whatever our default backdrop value is
            backdrop : (typeof options.backdrop  === 'undefined') ? _backdrop : options.backdrop,
            // ignore bootstrap's keyboard options; we'll handle this ourselves (more fine-grained control)
            keyboard : false,
            // @ see https://github.com/makeusabrew/bootbox/issues/69
            // we *never* want the modal to be shown before we can bind stuff to it
            // this method can also take a 'show' option, but we'll only use that
            // later if we need to
            show     : false
        });

        // @see https://github.com/makeusabrew/bootbox/issues/64
        // @see https://github.com/makeusabrew/bootbox/issues/60
        // ...caused by...
        // @see https://github.com/twitter/bootstrap/issues/4781
        div.on("show", function(e) {
            $(document).off("focusin.modal");
        });

        if (typeof options.show === 'undefined' || options.show === true) {
            div.modal("show");
        }

        return div;
    };

    /**
     * #modal is deprecated in v3; it can still be used but no guarantees are
     * made - have never been truly convinced of its merit but perhaps just
     * needs a tidyup and some TLC
     */
    that.modal = function(/*str, label, options*/) {
        var str;
        var label;
        var options;

        var defaultOptions = {
            "onEscape": null,
            "keyboard": true,
            "backdrop": _backdrop
        };

        switch (arguments.length) {
            case 1:
                str = arguments[0];
                break;
            case 2:
                str = arguments[0];
                if (typeof arguments[1] == 'object') {
                    options = arguments[1];
                } else {
                    label = arguments[1];
                }
                break;
            case 3:
                str     = arguments[0];
                label   = arguments[1];
                options = arguments[2];
                break;
            default:
                throw new Error("Incorrect number of arguments: expected 1-3");
                break;
        }

        defaultOptions['header'] = label;

        if (typeof options == 'object') {
            options = $.extend(defaultOptions, options);
        } else {
            options = defaultOptions;
        }

        return that.dialog(str, [], options);
    };


    that.hideAll = function() {
        $(".bootbox").modal("hide");
    };

    that.animate = function(animate) {
        _animate = animate;
    };

    that.backdrop = function(backdrop) {
        _backdrop = backdrop;
    };

    that.classes = function(classes) {
        _classes = classes;
    };

    /**
     * private API
     */

    /**
     * standard locales. Please add more according to ISO 639-1 standard. Multiple language variants are
     * unlikely to be required. If this gets too large it can be split out into separate JS files.
     */
    var _locales = {
        'en' : {
            OK      : 'OK',
            CANCEL  : 'Cancel',
            CONFIRM : 'OK'
        },
        'fr' : {
            OK      : 'OK',
            CANCEL  : 'Annuler',
            CONFIRM : 'D\'accord'
        },
        'de' : {
            OK      : 'OK',
            CANCEL  : 'Abbrechen',
            CONFIRM : 'Akzeptieren'
        },
        'es' : {
            OK      : 'OK',
            CANCEL  : 'Cancelar',
            CONFIRM : 'Aceptar'
        },
        'br' : {
            OK      : 'OK',
            CANCEL  : 'Cancelar',
            CONFIRM : 'Sim'
        },
        'nl' : {
            OK      : 'OK',
            CANCEL  : 'Annuleren',
            CONFIRM : 'Accepteren'
        },
        'ru' : {
            OK      : 'OK',
            CANCEL  : 'Отмена',
            CONFIRM : 'Применить'
        },
        'it' : {
            OK      : 'OK',
            CANCEL  : 'Annulla',
            CONFIRM : 'Conferma'
        }
    };

    function _translate(str, locale) {
        // we assume if no target locale is probided then we should take it from current setting
        if (locale == null) {
            locale = _locale;
        }
        if (typeof _locales[locale][str] === 'string') {
            return _locales[locale][str];
        }

        // if we couldn't find a lookup then try and fallback to a default translation

        if (locale != _defaultLocale) {
            return _translate(str, _defaultLocale);
        }

        // if we can't do anything then bail out with whatever string was passed in - last resort
        return str;
    }

    return that;

}(document, window.jQuery));

// @see https://github.com/makeusabrew/bootbox/issues/71
window.bootbox = bootbox;
this.cache = [];

function preloadImages(images) {
   for (var i = 0; i < images.length; i++) {
      var img = $('<img src="/images/layout/'+ images[i] + '" />');
      this.cache.push(img);
   }
}

preloadImages([
   'bouton-serveur.png',
   'bouton-serveur-2.png',
   'bouton-connexion.png',
   'bouton-connexion-2.png',
   'bouton-membre.png',
   'bouton-membre-2.png',

   'membre/accueil.png',
   'membre/accueil-2.png',
   'membre/discussions.png',
   'membre/discussions-2.png',
   'membre/projets.png',
   'membre/projets-2.png',
   'membre/evenements.png',
   'membre/evenements-2.png',
   'membre/profil.png',
   'membre/profil-2.png',
   'membre/membres.png',
   'membre/membres-2.png',
   'membre/don.png',
   'membre/don-2.png',

   'serveur/presentation.png',
   'serveur/presentation-2.png',
   'serveur/apercu.png',
   'serveur/apercu-2.png',
   'serveur/news.png',
   'serveur/news-2.png',
   'serveur/reglement.png',
   'serveur/reglement-2.png',
   'serveur/postulation.png',
   'serveur/postulation-2.png',
   'serveur/aide.png',
   'serveur/aide-2.png',
   'serveur/contact.png',
   'serveur/contact-2.png'
]);
function updateTopBottom() {
   $window = $(window);

   if ($window.scrollTop() > 100) {
      $('#page-scroller-top').fadeIn();
   } else {
      $('#page-scroller-top').fadeOut();
   }

   var height = $(document).height();
   height -= $window.scrollTop();
   height -= $window.height();
   if (height > 100) {
      $('#page-scroller-bottom').fadeIn();
   } else {
      $('#page-scroller-bottom').fadeOut();
   }
}

function scrollTo(y) {
   $('body,html').animate({
      scrollTop: y
   }, 800);
}

$(document).on('click.page-scroller.top',
      '#page-scroller-top', function (event) {
   event.preventDefault();
   scrollTo(0);
});

$(document).on('click.page-scroller.bottom',
      '#page-scroller-bottom', function (event) {
   event.preventDefault();
   scrollTo($(document).height());
});

$(document).ready(function() {
   $(window).scroll(updateTopBottom);
   $(document).on('insert', updateTopBottom);
   updateTopBottom(window);
});
$(document).on('click', '[data-logged-in="member"] .buttons',
      function(event) {

   event.preventDefault();
   var $visible = $('header #menu .submenu.submenu-visible');
   var $hidden  = $('header #menu .submenu.submenu-hidden');

   var name = ($(this).attr('id') == 'button1') ? 'server' : 'member';

   if ($visible.hasClass('submenu-' + name)) {
      return;
   }

   $visible.fadeOut(160, function() {
      $visible.toggleClass('submenu-visible submenu-hidden');
      $hidden.fadeIn(160, function() {
         $hidden.toggleClass('submenu-visible submenu-hidden');
      });
   });
});
function tabFor(url) {
   var match = (/.+\/(.+?)$/g).exec(url);
   var tabName = (match == null) ? '' : match[1];
   var realTabName = tabName;
   if (realTabName == null || realTabName == '') {
      realTabName = $('.tab-pane-default').attr('id');
   }
   return $('.page-tabs .tab a[data-target="#' + realTabName + '"]');
}

function displayTab(tab) {
   if (tab == null || tab.size() < 1) {
      return;
   }
   document.title = tab.data().title;
   tab.tab('show');
}

$(document).on('click.ethilvan.page-tab', 'ul#nav.page-tabs .tab a', function (event) {
   event.preventDefault();
   displayTab($(this));
   var newTab = $(this).attr('data-target').substring(1);
   window.history.pushState({}, null, newTab);
});

window.onpopstate = function(event) {
   displayTab(tabFor(window.location.pathname));
}

$(function() { displayTab(tabFor(window.location.pathname)); });
!function($) {

   var Selectpicker = function(element, options, e) {
      if (e) {
         e.stopPropagation();
         e.preventDefault();
      }
      this.$element = $(element);
      this.$newElement = null;
      this.selectClass = options.btnStyle || '';
      this.init();
   };

   Selectpicker.prototype = {

      contructor: Selectpicker,

      init: function (e) {
         this.$element.css('display', 'none');

         var template = this.getTemplate();
         template = this.createLi(template);
         this.$element.after(template);
         this.$newElement = this.$element.next('.bootstrap-select');
         this.$newElement.find('> a').addClass(this.selectClass);
         this.clickListener();
      },

      getTemplate: function() {
         var template =
            '<div class="btn-group bootstrap-select">' +
               '<a class="btn dropdown-toggle clearfix" ' +
                     'data-toggle="dropdown" href="#">' +
                  '<span class="filter-option pull-left">__SELECTED</span>' +
                  '<span class="caret pull-right"></span>' +
               '</a>' +
               '<ul class="dropdown-menu" role="menu">__ADD_LI</ul>' +
            '</div>';

         return template;
      },

      createLi: function(template) {
         var _li = [];
         var _liHtml = '';
         var _selected_index;

         if (this.$element.find('option:selected').index()) {
            _selected_index = this.$element.find('option:selected').index();
         } else {
            _selected_index = 0;
         }

         this.$element.find('option').each(function() {
            _li.push($(this).text());
         });

         if( _li.length > 0) {
            template = template.replace('__SELECTED', _li[_selected_index]);
            for (var i = 0; i < _li.length; i++) {
               _liHtml +=
                  '<li rel=' + i + '><a tabindex="-1" href="#">' +
                     _li[i] +
                  '</a></li>';
            }
         }

         this.$element.find('option')[_selected_index].
               setAttribute('selected', 'selected');

         template = template.replace('__ADD_LI', _liHtml);

         return template;
      },

      clickListener: function() {
         this.$newElement.find('li').on('click', function(e) {
            e.preventDefault();

            var $this = $(this),
               rel = $this.attr('rel'),
               $select = $this.parents('.bootstrap-select');

            $select.prev('select').find('option').removeAttr('selected');

            $select.prev('select').find('option')[parseInt(rel,10)]
               .setAttribute('selected', 'selected');

            $select.find('.filter-option').html($this.text());

            // Trigger select 'change'
            $select.prev('select').trigger('change');
         });
      }
   };

   $.fn.selectpicker = function(option, event) {
      return this.each(function () {
         var $this = $(this),
            data = $this.data('selectpicker'),
            options = typeof option == 'object' && option;
         if (!data) {
            $this.data('selectpicker',
                  (data = new Selectpicker(this, options, event)));
         }
         if (typeof option == 'string') {
            data[option]();
         }
      });
   };

   $(function() {
      $('select.bootstrap-select').selectpicker();
   });

   $(document).on('insert', function() {
      $('select.bootsrap-select').selectpicker();
   });
}(jQuery);
$(function() {

   var $container = $('.auto-fill');
   if ($container.size() < 1) {
      return;
   }

   var url = $container.data().autoFillUrl || '';
   var currentPage = 1;
   var isPageLoading = false;

   function nearBottomOfPage() {
      var $window = $(window);
      var y = $(document).height();
      y -= $window.height();
      y -= 200;
      return $window.scrollTop() > y;
   }

   $(window).scroll(function() {
      if (isPageLoading) {
         return;
      }

      if (nearBottomOfPage()) {
         isPageLoading = true;
         currentPage++;
         $.get(url + '?page=' + currentPage, function (html) {
            $container.append($(html).html());
            $(document).trigger('insert');
            isPageLoading = false;
         });
      }
   });
});
function MDEditor(wrapper) {

   this.initialize = function(wrapper) {
      this.$input      = wrapper.find('.mde-input');
      this.$preview    = wrapper.find('.mde-preview');
      this.$previewBtn = wrapper.find('.mde-dopreview');
      this.$spinner    = wrapper.find('.mde-spinner');

      this.membresMentions = false;
      this.emojisMentions  = false;
      this.updating        = false;
   };

   this.activateMentions = function() {
      var mdeditor = this;
      var $input = mdeditor.$input
      if (!mdeditor.membresMentions) {
         MDEditor.Utils.fetchMembresMentions(function(data) {
            $input.atwho('@', { data: data, limit: 5 });
            mdeditor.membresMentions = true;
         });
      }
      if (!mdeditor.emojisMentions) {
         MDEditor.Utils.fetchEmojisMentions(function(data) {
            $input.atwho(':', {
               data: data, limit: 10,
               tpl: MDEditor.Utils.emojiPreviewTemplate(),
            });
            mdeditor.emojisMentions = true;
         });
      }
   }

   this.updatePreview = function() {
      if (this.updating) {
         return;
      }

      this.updating = true;
      this.$previewBtn.addClass('disabled');
      this.$spinner.spin(MDEditor.Utils.spinOptions());

      var $mdeditor = this;
      $.ajax({
         url: '/markdown',
         type: 'POST',
         data: { content: $mdeditor.$input.val() },
         success: function(data, status, xhr) {
            $mdeditor.$preview.html(data);
            $mdeditor.updating = false;
            $mdeditor.$previewBtn.removeClass('disabled');
            $mdeditor.$spinner.spin(false);
         }
      });
   }

   this.action = function(options) {
      var actionName = options['name'];
      var actionMethod = MDEditor.Actions[actionName];
      if (!actionMethod) {
         return;
      }

      if (options['event'].preventDefault) {
         options['event'].preventDefault();
      }

      if (actionMethod(this.$input, options)) {
         this.updatePreview();
      }
   };

   this.initialize(wrapper);
}


MDEditor.Actions = {

   title: function($input, options) {
      var $control = options['control'];
      var level = parseInt($control.data().mdeTitle);
      if (isNaN(level)) {
         level = 1;
      }

      return MDEditor.Utils.insertAtStart($input, '#', true, level);
   },

   quote: function($input, options) {
      return MDEditor.Utils.insertAtStart($input, '>', false);
   },

   list: function($input, options) {
      return MDEditor.Utils.insertAtStart($input, '*', false);
   },

   link: function($input, options) {
      return MDEditor.Utils.insertLinkOrMedia($input, "[", "](", ")");
   },

   image: function($input, options) {
      return MDEditor.Utils.insertLinkOrMedia($input, "![", "](", ")");
   },

   bold: function($input, options) {
      return MDEditor.Utils.wrapSelectionOrInsert($input, '**');
   },

   italic: function($input, options) {
      return MDEditor.Utils.wrapSelectionOrInsert($input, '_');
   },

   strikethrough: function($input, options) {
      return MDEditor.Utils.wrapSelectionOrInsert($input, '~~');
   },

   code: function($input, options) {
      return MDEditor.Utils.wrapSelectionOrInsert($input, '`');
   },

   dopreview: function($input, options) {
      return true;
   }
}

MDEditor.Utils = {

   wrapSelectionOrInsert: function($input, chars) {
      var selection = $input.getSelection();
      if (selection.length == 0) {
         $input.insertAtCaretPos(chars);
         $input.insertAtCaretPos(chars);
         $input.setCaretPos(selection.start + chars.length + 1);
         return false;
      }

      var text = chars + selection.text + chars;
      $input.replaceSelection(text);
      $input.setSelection(selection.start, selection.start + text.length);
      return true;
   },

   insertAtStart: function($input, char, duplicate, countArg) {
      var content = $input.val();
      var selection = $input.getSelection();
      var start = selection.start;
      var count = duplicate ? countArg : 1;

      while (start >= 0 && content[start] != "\n") {
         start--;
      }

      $input.setSelection(start + 1, start + 1);
      var text = '';
      if (content[start + 1] != char) {
         text = this.repeatString(char, count) + ' ';
      } else if (duplicate) {
         text = this.repeatString(char, count);
      }

      $input.insertAtCaretPos(text);
      $input.setSelection(selection.start + text.length,
            selection.end + text.length);
      return text.length > 0;
   },

   repeatString: function(string, count) {
      return new Array(count + 1).join(string);
   },

   insertLinkOrMedia: function($input, chars1, chars2, chars3) {
      var url = prompt("Url :", "http://");
      if (url == null || url == "http://") {
         return false;
      }

      var selection = $input.getSelection();
      var text = selection.text;
      if (selection.length == 0) {
         text = prompt("Texte :");
         if (text == null) {
            return false;
         }
      }

      if (selection.length == 0) {
         $input.insertAtCaretPos(chars1 + text + chars2 + url + chars3);
      } else {
         $input.replaceSelection(chars1 + text + chars2 + url + chars3);
      }
      return true;
   },

   fetchMembresMentions: function(callback) {
      this.fetchMentions('/markdown/membres.json', callback);
   },

   fetchEmojisMentions: function(callback) {
      this.fetchMentions('/markdown/emojis.json', callback);
   },

   fetchMentions: function(url, callback) {
      var utils = this;
      if (utils[url]) {
         callback(utils[url]);
      } else {
         $.ajax({
            url: url,
            success: function(raw_data, status, xhr) {
               var data = $.map(raw_data, function(name, i) {
                  return { 'name': name };
               });
               utils[url] = data;
               callback(data);
            }
         });
      }
   },

   emojiPreviewTemplate: function() {
      var template =
         "<li data-value='${name}:'>" +
         "  ${name} " +
         "   <img src='/images/emoji/${name}.png' height='20' width='20' />" +
         "</li>"

      return template;
   },

   spinOptions: function() {
      return {
        lines: 11,
        length: 1,
        width: 3,
        radius: 6,
        corners: 1,
        rotate: 0,
        speed: 1,
        trail: 60,
        shadow: true,
        hwaccel: false,
        className: 'spinner',
        zIndex: 2e9,
        top: 'auto',
        left: 'auto'
      };
   }
}

var actionsSelector = Object.keys(MDEditor.Actions).map(function(action) {
   return '[href=#mde-' + action + ']';
}).join(', ');

$(document).on('click.mdeditor.actions',
      actionsSelector, function(event) {
   var $control = $(this);
   var actionName = (/^#mde-(.+)$/).exec($control.attr('href'))[1];
   $control.mdeditor('action', {
      name: actionName,
      event: event,
      control: $control,
   });
});


$(document).on('keypress.mdeditor.preview.shortcut',
      '.mde-input', function(event) {
   if (event.which == 13) {
      $(this).mdeditor('updatePreview');
   }
});

$(document).on('focus.mdeditor.atwho',
      '.mde-input', function(event) {
   $(this).mdeditor('activateMentions');
});

$.fn.mdeditor = function(method, arg) {
   return this.each(function() {
      var $mdeditor = $(this).parents('.mdeditor');
      if (!$mdeditor) {
         return null;
      }

      var data = $mdeditor.data('mdeditor');
      if (!data) {
         data = new MDEditor($mdeditor);
         $mdeditor.data('mdeditor', data);
      }

      if (method) {
         data[method](arg);
      }
  });
}
bootbox.setLocale('fr');

$(document).on('click.ethilvan.confirmation', 'a.need-confirmation', function (event, data) {
   var $this = $(this);
   if (data == 'confirmed') {
      window.location = $this.attr('href');
      return;
   }

   event.preventDefault();
   bootbox.confirm("Etes vous sûr ?", "Annuler", "Confirmer", function(result) {
      if (result) {
         $this.trigger('click', ['confirmed']);
      }
   });
});
window.ParsleyConfig = window.ParsleyConfig || {};

(function ($) {
  window.ParsleyConfig = $.extend( true, {}, window.ParsleyConfig, {
    messages: {
      // parsley //////////////////////////////////////
        defaultMessage: "Cette valeur semble non valide."
      , type: {
            email:      "Cette valeur n'est pas une adresse email valide."
          , url:        "Cette valeur n'est pas une URL valide."
          , urlstrict:  "Cette valeur n'est pas une URL valide."
          , number:     "Cette valeur doit être un nombre."
          , digits:     "Cette valeur doit être numérique."
          , dateIso:    "Cette valeur n'est pas une date valide (YYYY-MM-DD)."
          , alphanum:   "Cette valeur doit être alphanumérique."
        }
      , notnull:        "Cette valeur ne peut pas être nulle."
      , notblank:       "Cette valeur ne peut pas être vide."
      , required:       "Ce champ est requis."
      , regexp:         "Cette valeur semble non valide."
      , min:            "Cette valeur ne doit pas être inféreure à %s."
      , max:            "Cette valeur ne doit pas excéder %s."
      , range:          "Cette valeur doit être comprise entre %s et %s."
      , minlength:      "Cette chaîne est trop courte. Elle doit avoir au minimum %s caractères."
      , maxlength:      "Cette chaîne est trop longue. Elle doit avoir au maximum %s caractères."
      , rangelength:    "Cette valeur doit contenir entre %s et %s caractères."
      , equalto:        "Cette valeur devrait être identique."
      , mincheck:       "Vous devez sélectionner au moins %s choix."
      , maxcheck:       "Vous devez sélectionner %s choix maximum."
      , rangecheck:     "Vous devez sélectionner entre %s et %s choix."

      // parsley.extend ///////////////////////////////
      , minwords:       "Cette valeur doit contenir plus de %s mots."
      , maxwords:       "Cette valeur ne peut pas dépasser %s mots."
      , rangewords:     "Cette valeur doit comprendre %s à %s mots."
      , greaterthan:    "Cette valeur doit être plus grande que %s."
      , lessthan:       "Cette valeur doit être plus petite que %s."
    }
  });
}(window.jQuery || window.Zepto));
$(function() {

   $('[data-text-counter]').each(function() {
      var $this = $(this);
      var data = $this.data();

      var min = data.textCounterMin || data.minlength || null;
      var max = data.textCounterMin || data.maxlength || null;

      $this.miniCount({
         min: min,
         max: max,
         className: 'text-counter',
         validClassName: 'text-counter-valid',
         invalidClass: 'text-counter-invalid',
      });
   });
});
$(document).on('click.ethivan.inline', 'a[data-inline-target]', function (event) {
   var $this = $(this);
   event.preventDefault();

   $.ajax({
      url: $this.attr('href'),
      success: function(data, status, xhr) {
         var $target = $this.closest($this.data().inlineTarget);
         var $element = $(data);
         $element.css('display', 'none');
         $target.fadeOut(800, function() {
            $target.replaceWith($element);
            $element.fadeIn(800);
         });
      }
   });
});

$(document).on('click.ethilvan.remove', 'a[data-remove-target]', function (event) {
   var $this = $(this);
   event.preventDefault();

   bootbox.confirm("Etes vous sûr ?", "Annuler", "Confirmer", function(result) {
      if (!result) {
         return;
      }

      $.ajax({
         url: $this.attr('href'),
         success: function(data, status, xhr) {
            var $target = $this.closest($this.data().removeTarget);
            $target.slideUp(800, function() {
               $target.remove();
            });
         }
      });
   });
});
$(function() {

   var $form = $('#postulation-form');
   if ($form.size() < 1) {
      return;
   }

   var disableField = function(fieldContainer) {
      var field = fieldContainer.find('textarea, select');
      field.parsley('destroy');
      fieldContainer.slideUp(400);
   }

   var enableField = function(fieldContainer) {
      var field = fieldContainer.find('textarea, select');
      field.parsley();
      fieldContainer.slideDown(400);
   }

   var oldServer = $form.find('.field-postulation_old_server');
   var oldServerReason = $form.find('.field-postulation_old_server_reason');
   var onMultiMinecraftChange = function(multiMinecraft) {
      if (multiMinecraft.is(':checked')) {
         enableField(oldServer);
         enableField(oldServerReason);
      } else {
         disableField(oldServer);
         disableField(oldServerReason);
      }
   }

   var mumbleOther = $form.find('.field-postulation_mumble_other');
   var onMumbleChange = function(mumbleSelect) {
      if (mumbleSelect.val() == 'Autre') {
         enableField(mumbleOther);
      } else {
         disableField(mumbleOther);
      }
   }

   var mumble = $form.find('.field-postulation_mumble');
   var onMicrophoneChange = function(microphone) {
      if (microphone.is(':checked')) {
         enableField(mumble);
         onMumbleChange($form.find('.field-postulation_mumble select'));
      } else {
         disableField(mumble);
         disableField(mumbleOther);
      }
   }

   $form.find('.field-postulation_multi_minecraft input[type=checkbox]').change(function() {
      onMultiMinecraftChange($(this));
   });
   $form.find('.field-postulation_microphone input[type=checkbox]').change(function() {
      onMicrophoneChange($(this));
   });
   $form.find('.field-postulation_mumble select').change(function() {
      onMumbleChange($(this));
   });

   onMultiMinecraftChange($form.find('.multi_minecraft input[type=checkbox]'));
   onMicrophoneChange($form.find(' .microphone input[type=checkbox]'));
   onMumbleChange($form.find('.mumble select'));

   var screensNextId = $form.find('fieldset.field-screen').size();
   var screensCount = screensNextId;

   var replaceScreenTitle = function(screen) {
      var title = $(screen).find('h4');
      title.html(title.html().replace(/Screenshot [0-9]+/,
            'Screenshot ' + screensCount));
   };

   var onScreenRemove = function(event) {
      event.preventDefault();
      $(this).parent().remove();

      screensCount = 0;
      $form.find('fieldset.field-screen').each(function() {
         screensCount += 1;
         replaceScreenTitle($(this));
      });
   };

   $('.add-screen').click(function(event) {
      event.preventDefault();

      screensNextId++;
      screensCount++;
      var template = $form.find('.field-screen-template').html();
      template = template.replace(/%%template%%/g, screensNextId);
      var newScreen = $('<fieldset class="field-screen">' +
            template +
            '</fieldset>');
      replaceScreenTitle(newScreen);
      newScreen.find('.remove-screen').click(onScreenRemove);
      $(this).before(newScreen);
   });

   $('.remove-screen').click(onScreenRemove);

   // Activate first tab pane which contains errors
   var activateFirstTabWithErrors = function() {
      $form.find('.tab-pane').each(function() {
         var tabPane = $(this);

         if (tabPane.find('.errors, .parsley-error-list').size() > 0) {
            var tab = $('.nav-postulation-form a[href="#' + tabPane.attr('id') + '"]');
            tab.tab('show');
            return false;
         }
      });
   };

   window.ParsleyConfig = $.extend(true, {}, window.ParsleyConfig, {
      listeners: {
         onFormSubmit: function(isFormValid, event, ParsleyForm) {
            activateFirstTabWithErrors();
         }
      }
   });

   activateFirstTabWithErrors();
});

$(document).on('click', 'a[data-toggle="next-pill"]', function(event) {
   event.preventDefault();

   var $nav = $($(this).data().navTarget);
   var $active = $nav.find('.active');
   if ($active.size() < 1) {
      var $nextPill = $nav.find('li').first();
   } else {
      var $nextPill = $active.next();
   }

   if ($nextPill.size() < 1) {
      return;
   }

   $nextPill.find('a[data-toggle]').trigger('click');
   $('body,html').animate({
      scrollTop: $nav.offset().top - 10
   }, 800);
});
