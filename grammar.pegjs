// Aziis98 Data Grammar
// ==========================
//

{
	function AdonSymbol(text) {
	  this.text = text;
	}
	
	function Measure(value, unit) {
	  this.value = value;
		this.unit = unit;
	}
}

start
	= root:PropertyList
  
PropertyList
	= head:(_ KeyValue)? tail:(nl _ KeyValue)* blank {
	  if (head) {
		return [head[1]].concat(tail.map(prop => prop[2]))
			.reduce((prop, acc) => Object.assign(acc, prop), {});
		}
		else {
		  return { /* empty */ };
		}
	}
  
KeyValue
	= KeyValueAssing / KeyList / KeyObject
  
KeyValueAssing
	= key:Key _ "="? _ value:Value { return { [key]: value } }
KeyList
	= key:Key _ list:List { return { [key]: list } }
KeyObject
	= key:Key _ object:Object { return { [key]: object } }
  
// Values
// ------

Value
	= value:(Identifier / String / Number / Object / List) { return value }

Object
	= "{" nl pl:PropertyList "}" { 
	  return pl
	}
  
List
	= "[" blank values:( Value blank? ","? blank? )* "]" {
	  return values.map(value => value[0])
	}
  
Key
	= id:Identifier { return id.text }
	
// Identifier
// ----------

Identifier "identifier"
	= IdentifierStart IdentifierPart* { return new AdonSymbol(text().trim()) }

IdentifierStart
	= [^\n\r\t={}\[\]"' 0-9]
IdentifierPart
	= [^\n\r\t={}\[\]'"]

// Word
//	= [a-zA-Z][^ \t\n\r={}\[\],""]* { return text() }

// Numbers
// -------

Number
	= HexInteger / Measure / Decimal / Integer

Measure
	= value:(Decimal / Integer / HexInteger) _? unit:([a-zA-Z][a-zA-Z0-9]) { return new Measure(value, unit.join('')) }
HexInteger "hexnum"
	= "0x" [0-9a-fA-F]+ { return parseInt(text().substr(2), 16) }
Decimal "decimal"
	= [0-9]+ "." [0-9]+ { return parseFloat(text(), 10) }
Integer "integer"
	= [0-9]+ { return parseInt(text(), 10); }

// String
// ------

String "string"
	= '"' string:([^\n\r"] / '\\"')* '"' { return string.join('') }

// Whitespaces
// -----------

blank
	= [ \t\n\r]+ / EOF
	
nl "newline"
	= [ \t]*[\n\r] blank

_ "whitespace"
	= [ \t]*
			  
EOF
	= !.