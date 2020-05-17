#version 450
#define M_PI 3.1415926535897932384626433832795

in vec2 Texcoord;
in vec2 Coords;
uniform sampler2D texture_sampler;

out vec4 outColor;

#define PLAYER_R_WON 3
#define PLAYER_L_WON 2

uniform game_data{
    vec2 playerL;
    vec2 playerR;
    vec2 ball;
    vec2 fieldSize;
    int timeMS;
    int gameState;
    float stateAge;
};

uniform config_data{
    float faceSize;
    float ballSize;
    float ballEffectSize;
};

//Debug function, to mark unused variables as used! Don't use!
void use(vec2 param){if(sin(param.x) > 2.0)outColor = texture2D(texture_sampler, Texcoord);}

vec2 rotate(vec2 center, vec2 position, float angle, float stretch, float skew){
	vec2 normCoords = position - center;

	float cos = cos(angle * stretch);
	float sin = sin(angle * skew);
	float nx = cos * normCoords.x + sin * normCoords.y;
	float ny = cos * normCoords.y - sin * normCoords.x;

	return vec2(nx, ny) + center;
}

float flattenFromInfinity(float zeropoint, float x, float flatness){
    if(x > zeropoint) return 0.0;
    float mx = x - zeropoint;
    return -(mx*mx*mx)/(flatness*x);
}

vec2 distortPosition(vec2 incoords, vec2 center, float radius){
    vec2 st = incoords;
    vec2 mt = center;
    float dx = st.x - mt.x;
    float dy = st.y - mt.y;
    float dist = sqrt(dx * dx + dy * dy);

    if(dist > radius)
        return incoords;
    float pull = flattenFromInfinity(radius, dist, 500000);

    vec2 r = rotate(mt,st,pull*pull, 1.0, 0.8);
    return r;
}

vec2 distortPlayerPosition(vec2 incoords, vec2 center, float radius){
    float distance = distance(incoords, center);
    float distPerc = distance / (radius*1.2);

    vec2 dirUnit = normalize(incoords - center);

    return center + dirUnit*(distPerc)*radius;
}

vec4 applyColor(vec4 incolor, vec2 pos, float size){
    float pull = flattenFromInfinity(size, distance(Coords, pos), 500000);
    return incolor - vec4(pull*0.2);
}

vec4 applyPlayerColor(vec4 incolor, vec2 pos, float size, vec3 color){

    float dist = distance(Coords, pos);
    if(dist > size){
        return incolor;
    }

    float glam = 0.0f;

    glam = dist / size;
    glam = glam * glam;

    return mix(incolor*(1+glam),vec4(color,1.0), 0.5);
}

vec2 applyDistortions(){
    vec2 curr = Coords;
    if(distance(curr, playerR) < faceSize){
        return distortPlayerPosition(curr, playerR, faceSize);
    }
    if(distance(curr, playerL) < faceSize){
        return distortPlayerPosition(curr, playerL, faceSize);
    }
    curr = distortPosition(curr, ball, ballEffectSize);
    return curr;
}

vec2 mirror(vec2 inpos){
    return vec2(-inpos.x, inpos.y);
}

vec4 applyColors(vec4 incolor){
    incolor = applyPlayerColor(incolor, playerR, faceSize, vec3(1.0,0.0,0.0));
    incolor = applyPlayerColor(incolor, playerL, faceSize, vec3(0.0,1.0,0.0));
    incolor = applyColor(incolor, ball, ballEffectSize);
    return incolor;
}

void main()
{
    //TODO invent colors for clipping out of image
    outColor = applyColors(texture2D(texture_sampler, applyDistortions()/fieldSize));
    use(Texcoord);
}