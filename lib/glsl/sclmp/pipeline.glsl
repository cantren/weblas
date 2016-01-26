precision highp float;

varying vec2      outTex;	// texture coords of row/column to calculate
uniform sampler2D X;		// texture with data from padded A
uniform int       N;		// number of columns
uniform int       pad;		// additional columns to nearest multiple of four
uniform float     a; 		// lower bound
uniform float     b; 		// upper bound


#pragma glslify: fix_pad = require(../fix_pad)


void main(void) {

	// get the implied row and column from .y and .x of passed (output)
	// texture coordinate. These map directly to input texture space when
	// the relevant dimensions are the same.
	float row = outTex.y;
	float col = outTex.x;

	// direct usage of col requires output be padded exactly like input
	vec4 x = texture2D( X, vec2(col, row));
	vec4 val_v = clamp(x, a, b);

	// fix padded region
	if(col * float(N + pad) > float(N) ) {
		fix_pad(val_v, pad);
	}

	gl_FragColor = val_v;
}