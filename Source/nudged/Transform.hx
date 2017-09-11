package nudged;

class Transform{

    public static var IDENTITY = new Transform(1,0,0,0);
    public var s:Float;
    public var r:Float;
    public var tx:Float;
    public var ty:Float;

    public function new(scale:Float = 1, rotation:Float = 0, tx:Float = 0, ty:Float = 0){

        this.s  = scale;
        this.r  = rotation;
        this.tx = tx;
        this.ty = ty;

    }


    public function equals(t:Transform){

        return (s == t.s && r == t.r && tx == t.tx && ty == t.ty);
    
    }


    public function getMatrix(){

        return { a: s, b: r, c: -r, d: s, e: tx, f: ty };

    }


    public function getRotation(){ //Radians

        return Math.atan2(r, s);

    }


    public function getScale(){

        return Math.sqrt(r * r + s * s);

    }


    public function getTranslation(){

        return [tx, ty];

    }


    public function toArray(){

        return [s, r, tx, ty];

    }


    public function transform(points:Array<Float>){ // Array[point1.x, point1.y, ... pointn.x, pointx.y];

        var c:Array<Float> = [];
        var x,y;

        for (i in 0...Math.round(points.length / 2)) {

            x = i * 2;
            y = x + 1;

            c.push( s * points[x] - r * points[y] + tx );
            c.push( r * points[x] + s * points[y] + ty );
        
        }
        
        return c;

    }


    public function inverse(){

        var det = s * s + r * r;
        var eps = 0.00000001;

        if (Math.abs(det) < eps) return null;
        
        var shat = s / det;
        var rhat = -r / det;
        var txhat = (-s * tx - r * ty) / det;
        var tyhat = ( r * tx - s * ty) / det;
        
        return new Transform(shat, rhat, txhat, tyhat);

    }


    public function translateBy(dx:Float, dy:Float){

        return new Transform(s, r, tx + dx, ty + dy);

    }


    public function scaleBy(multiplier:Int, ?pivot:Array<Float>){ // (i, [x,y])

        var m, x, y;
        
        m = multiplier;
        x = pivot == null ? 0 : pivot[0];
        y = pivot == null ? 0 : pivot[1];
        
        return new Transform(m * s, m * r, m * tx + (1-m) * x, m * ty + (1-m) * y);

    }


    public function rotateBy(radians:Float, ?pivot:Array<Float>){

        var co, si, x, y, shat, rhat, txhat, tyhat;
    
        co      = Math.cos(radians);
        si      = Math.sin(radians);
        x       = pivot == null ? 0 : pivot[0];
        y       = pivot == null ? 0 : pivot[1];
        shat    = s * co - r * si;
        rhat    = s * si + r * co;
        txhat   = (tx - x) * co - (ty - y) * si + x;
        tyhat   = (tx - x) * si + (ty - y) * co + y;
        
        return new Transform(shat, rhat, txhat, tyhat);
    
    }


    public function multiplyBy(t:Transform){

        var shat    = s * t.s - r * t.r;
        var rhat    = s * t.r + r * t.s;
        var txhat   = s * t.tx - r * t.ty + tx;
        var tyhat   = r * t.tx + s * t.ty + ty;
        
        return new Transform(shat, rhat, txhat, tyhat);

    }


}