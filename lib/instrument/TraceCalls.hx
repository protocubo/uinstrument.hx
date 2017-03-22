package instrument;

import haxe.macro.Expr;

class TraceCalls {
	public static dynamic function onCalled(?pos:haxe.PosInfos)
		haxe.Log.trace('CALL ${pos.className}.${pos.methodName}', pos);

#if macro
	public static function hijack(type:String, ?field:String)
		Instrument.hijack(instrument.TraceCalls.embed, type, field);

	@:allow(instrument.Instrument)
	static function embed(field:Field, fun:Function):Function
	{
		if (fun.expr == null)
			return fun;
		fun.expr = macro @:pos(field.pos) {
			@:pos(fun.expr.pos) instrument.TraceCalls.onCalled();
			${fun.expr};
		}
		return fun;
	}
#end
}
