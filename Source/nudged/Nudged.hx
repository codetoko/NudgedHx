package nudged;

import nudged.Transform;

class Nudged{

    public static function estimateR(domain:Array<Float>, range:Array<Float>, ?pivot:Array<Float>){

        var N, D, a0, b0, a, b, c, d, ac, ad, bc, bd, shat, rhat, tx, ty;

        N = Math.min(domain.length, range.length);
        ac = ad = bc = bd = 0.0;

        if (pivot == null) {

            a0 = b0 = 0.0;
        
        } else {
        
            a0 = pivot[0];
            b0 = pivot[1];
        
        }

        for (i in 0...Math.round(N/2)) {

            var x = i * 2;
            var y = x + 1;

            a = domain[x] - a0;
            b = domain[y] - b0;
            c = range[x] - a0;
            d = range[y] - b0;
            ac += a * c;
            ad += a * d;
            bc += b * c;
            bd += b * d;

        }

        var p = ac + bd;
        var q = ad - bc;

        D = Math.sqrt(p * p + q * q);

        if (D == 0) {

            return Transform.IDENTITY;

        }

        shat    = p / D;
        rhat    = q / D;
        tx      = a0 - a0 * shat + b0 * rhat;
        ty      = b0 - a0 * rhat - b0 * shat;

        return new Transform(shat, rhat, tx, ty);

    }


    public static function estimateS(domain:Array<Float>, range:Array<Float>, ?pivot:Array<Float>){

        var N, D, a0, b0, a, b, c, d, ac, bd, aa, bb, shat, tx, ty;

        N = Math.min(domain.length / 2, range.length / 2);
        ac = bd = aa = bb = 0.0;

        if (pivot == null) {

            a0 = b0 = 0.0;
        
        } else {
        
            a0 = pivot[0];
            b0 = pivot[1];
        
        }

        for (i in 0...Math.round(N/2)) {

            var x = i * 2;
            var y = x + 1;
            
            a = domain[x] - a0;
            b = domain[y] - b0;
            c = range[x] - a0;
            d = range[y] - b0;
            ac += a * c;
            bd += b * d;
            aa += a * a;
            bb += b * b;
        
        }

        D = aa + bb;

        if (D == 0) return Transform.IDENTITY;

        shat = Math.max(0, (ac + bd) / D);
        tx = (1 - shat) * a0;
        ty = (1 - shat) * b0;

        return new Transform(shat, 0, tx, ty);

    }


    public static function estimateSR(domain:Array<Float>, range:Array<Float>, ?pivot:Array<Float>){

        var X, Y, N, s, r, tx, ty;

        if (pivot == null) {
            pivot = [0.0, 0.0];
        }

        X = domain;
        Y = range;

        N = Math.min(X.length, Y.length);

        var v = pivot[0];
        var w = pivot[1];

        var a, b, c, d;
        var a2, b2;
        a2 = b2 = 0.0;
        var ac, bd, bc, ad;
        ac = bd = bc = ad = 0.0;

        for (i in 0...Math.round(N/2)) {

            var x = i * 2;
            var y = x + 1;
            
            a = X[x] - v;
            b = X[y] - w;
            c = Y[x] - v;
            d = Y[y] - w;
            a2 += a * a;
            b2 += b * b;
            ac += a * c;
            bd += b * d;
            bc += b * c;
            ad += a * d;
        }

        var den = a2 + b2;
        var eps = 0.00000001;

        if (Math.abs(den) < eps) {

            return Transform.IDENTITY;

        }

        s   = (ac + bd) / den;
        r   = (-bc + ad) / den;
        tx  =  w * r - v * s + v;
        ty  = -v * r - w * s + w;

        return new Transform(s, r, tx, ty);

    }


    public static function estimateT(domain:Array<Float>, range:Array<Float>){
    
        var N, a1, b1, c1, d1, txhat, tyhat;

        N = Math.round(Math.min(domain.length / 2, range.length / 2));
        a1 = b1 = c1 = d1 = 0.0;

        if (N < 1) return Transform.IDENTITY;

        for (i in 0...N) {

            var x = i * 2;
            var y = x + 1;

            a1 += domain[x];
            b1 += domain[y];
            c1 += range[x];
            d1 += range[y];
        
        }

        txhat = (c1 - a1) / N;
        tyhat = (d1 - b1) / N;

        return new Transform(1, 0, txhat, tyhat);
    
    }


    public static function estimateTR(domain:Array<Float>, range:Array<Float>){
        
        var X = domain;
        var Y = range;
        var N = Math.round(Math.min(X.length / 2, Y.length / 2));
        var a, b, c, d, a1, b1, c1, d1, ac, ad, bc, bd;
        
        a1 = b1 = c1 = d1 = ac = ad = bc = bd = 0.0;
        
        for (i in 0...N) {

            var x = i * 2;
            var y = x + 1;

            a = X[x];
            b = X[y];
            c = Y[x];
            d = Y[y];
            a1 += a;
            b1 += b;
            c1 += c;
            d1 += d;
            ac += a * c;
            ad += a * d;
            bc += b * c;
            bd += b * d;

        }

        var v = N * (ad - bc) - a1 * d1 + b1 * c1;
        var w = N * (ac + bd) - a1 * c1 - b1 * d1;
        var D = Math.sqrt(v * v + w * w);

        if (D == 0) {

            if (N == 0) return Transform.IDENTITY;

            return new Transform(1, 0, (c1 - a1) / N, (d1 - b1) / N);
        
        }

        var shat    = w / D;
        var rhat    = v / D;
        var txhat   = (-a1 * shat + b1 * rhat + c1) / N;
        var tyhat   = (-a1 * rhat - b1 * shat + d1) / N;

        return new Transform(shat, rhat, txhat, tyhat);
    
    }


    public static function estimateTS(domain:Array<Float>, range:Array<Float>){
    
        var X = domain;
        var Y = range;
        var N = Math.round(Math.min(X.length / 2, Y.length / 2));
        var a, b, c, d, a1, b1, c1, d1, a2, b2, ac, bd;
        a = b = c = d = a1 = b1 = c1 = d1 = a2 = b2 = ac = bd = 0.0;
        
        for (i in 0...N) {

            var x = i * 2;
            var y = x + 1;

            a = X[x];
            b = X[y];
            c = Y[x];
            d = Y[y];
            a1 += a;
            b1 += b;
            c1 += c;
            d1 += d;
            a2 += a * a;
            b2 += b * b;
            ac += a * c;
            bd += b * d;
        }

        var N2 = N * N;
        var a12 = a1 * a1;
        var b12 = b1 * b1;
        var p = a2 + b2;
        var q = ac + bd;
        var D = N2 * p - N * (a12 + b12);

        if (D == 0) {

            if (N == 0) return Transform.IDENTITY;
            return new Transform(1, 0, (c1 / N) - a, (d1 / N) - b);
        
        }

        var shat = (N2 * q - N * (a1 * c1 + b1 * d1)) / D;
        var txhat = (-N * a1 * q + N * c1 * p - b12 * c1 + a1 * b1 * d1) / D;
        var tyhat = (-N * b1 * q + N * d1 * p - a12 * d1 + a1 * b1 * c1) / D;

        return new Transform(shat, 0, txhat, tyhat);
    
    }


    public static function estimateTSR(domain:Array<Float>, range:Array<Float>){
        
        var X, Y, N, s, r, tx, ty;


        X = domain;
        Y = range;
        var N = Math.round(Math.min(X.length / 2, Y.length / 2));

        if (N == 0) return Transform.IDENTITY;

        var a, b, c, d, a1, b1, c1, d1, a2, b2, ad, bc, ac, bd;
        a = b = c = d = a1 = b1 = c1 = d1 = a2 = b2 = ad = bc = ac = bd = 0.0;
        
        for (i in 0...N) {

            var x = i * 2;
            var y = x + 1;

            a = X[x];
            b = X[y];
            c = Y[x];
            d = Y[y];
            a1 += a;
            b1 += b;
            c1 += c;
            d1 += d;
            a2 += a * a;
            b2 += b * b;
            ad += a * d;
            bc += b * c;
            ac += a * c;
            bd += b * d;
        }

        var den = N * a2 + N * b2 - a1 * a1 - b1 * b1;
        var eps = 0.00000001;

        if (-eps < den && den < eps) return new Transform(1, 0, (c1 / N) - a, (d1 / N) - b);

        s   = (N * (ac + bd) - a1 * c1 - b1 * d1) / den;
        r   = (N * (ad - bc) + b1 * c1 - a1 * d1) / den;
        tx  = (-a1 * (ac + bd) + b1 * (ad - bc) + a2 * c1 + b2 * c1) / den;
        ty  = (-b1 * (ac + bd) - a1 * (ad - bc) + a2 * d1 + b2 * d1) / den;

        return new Transform(s, r, tx, ty);

    }



}