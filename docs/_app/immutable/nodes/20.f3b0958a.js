import{S as Er,i as Rr,s as Ar,k as w,q as m,a as T,L as ae,e as de,l as y,m as p,r as _,h as c,c as C,M as oe,n as t,K as Dr,b as ne,C as r,O as Fr,u as Ye,D as zt,Q as et,E as ur,o as Pr,p as Tr,P as hr,R as Cr,y as De,z as Fe,A as Pe,g as Te,d as Ce,B as Ve}from"../chunks/index.d6d9c1d5.js";import{H as Vr}from"../chunks/global.556b643d.js";import{s as Sr,l as zr}from"../chunks/simple-statistics.c7340a6c.js";import{s as Ir,r as $r}from"../chunks/stores.64de824d.js";import{c as Nr}from"../chunks/csv.3ac754ad.js";import{S as Hr}from"../chunks/SelectRegions.96403af0.js";const Mr=!0,Gr=Object.freeze(Object.defineProperty({__proto__:null,prerender:Mr},Symbol.toStringTag,{value:"Module"}));function dr(e,a,s){const o=e.slice();return o[33]=a[s],o[35]=s,o}function fr(e,a,s){const o=e.slice();return o[33]=a[s],o[35]=s,o}function pr(e,a,s){const o=e.slice();return o[35]=a[s],o}function vr(e,a,s){const o=e.slice();return o[39]=a[s],o[35]=s,o}function mr(e){let a,s,o,n,u=(100*e[39]).toFixed(0)+"",F,f,A,h,k,E;return{c(){a=ae("line"),n=ae("text"),F=m(u),f=m("%"),h=ae("line"),this.h()},l(g){a=oe(g,"line",{class:!0,x1:!0,y1:!0,x2:!0,y2:!0}),p(a).forEach(c),n=oe(g,"text",{class:!0,x:!0,y:!0,"text-anchor":!0});var b=p(n);F=_(b,u),f=_(b,"%"),b.forEach(c),h=oe(g,"line",{class:!0,x1:!0,y1:!0,x2:!0,y2:!0}),p(h).forEach(c),this.h()},h(){t(a,"class","grid svelte-zm4pmy"),t(a,"x1","40"),t(a,"y1",s=30+e[35]*e[11]),t(a,"x2",e[2]),t(a,"y2",o=30+e[35]*e[11]),t(n,"class","axis-label svelte-zm4pmy"),t(n,"x","35"),t(n,"y",A=35+e[35]*e[11]),t(n,"text-anchor","end"),t(h,"class","grid-white svelte-zm4pmy"),t(h,"x1","37"),t(h,"y1",k=30+e[35]*e[11]),t(h,"x2","45"),t(h,"y2",E=30+e[35]*e[11])},m(g,b){ne(g,a,b),ne(g,n,b),r(n,F),r(n,f),ne(g,h,b)},p(g,b){b[0]&2048&&s!==(s=30+g[35]*g[11])&&t(a,"y1",s),b[0]&4&&t(a,"x2",g[2]),b[0]&2048&&o!==(o=30+g[35]*g[11])&&t(a,"y2",o),b[0]&16&&u!==(u=(100*g[39]).toFixed(0)+"")&&Ye(F,u),b[0]&2048&&A!==(A=35+g[35]*g[11])&&t(n,"y",A),b[0]&2048&&k!==(k=30+g[35]*g[11])&&t(h,"y1",k),b[0]&2048&&E!==(E=30+g[35]*g[11])&&t(h,"y2",E)},d(g){g&&c(a),g&&c(n),g&&c(h)}}}function _r(e){let a,s,o,n,u,F=(100*e[35]*e[8]).toLocaleString()+"",f,A,h,k,E,g,b,z,O;return{c(){a=ae("line"),u=ae("text"),f=m(F),A=m("%"),E=ae("line"),this.h()},l(v){a=oe(v,"line",{class:!0,x1:!0,y1:!0,x2:!0,y2:!0}),p(a).forEach(c),u=oe(v,"text",{class:!0,x:!0,y:!0,"text-anchor":!0});var R=p(u);f=_(R,F),A=_(R,"%"),R.forEach(c),E=oe(v,"line",{class:!0,x1:!0,y1:!0,x2:!0,y2:!0}),p(E).forEach(c),this.h()},h(){t(a,"class","grid svelte-zm4pmy"),t(a,"x1",s=45+e[35]*e[7]),t(a,"y1","22"),t(a,"x2",o=45+e[35]*e[7]),t(a,"y2",n=e[3]-20),t(u,"class","axis-label svelte-zm4pmy"),t(u,"x",h=47+e[35]*e[7]),t(u,"y",k=e[3]-10),t(u,"text-anchor","end"),t(E,"class","grid-white svelte-zm4pmy"),t(E,"x1",g=45+e[35]*e[7]),t(E,"y1",b=e[3]-25),t(E,"x2",z=45+e[35]*e[7]),t(E,"y2",O=e[3]-30)},m(v,R){ne(v,a,R),ne(v,u,R),r(u,f),r(u,A),ne(v,E,R)},p(v,R){R[0]&128&&s!==(s=45+v[35]*v[7])&&t(a,"x1",s),R[0]&128&&o!==(o=45+v[35]*v[7])&&t(a,"x2",o),R[0]&8&&n!==(n=v[3]-20)&&t(a,"y2",n),R[0]&256&&F!==(F=(100*v[35]*v[8]).toLocaleString()+"")&&Ye(f,F),R[0]&128&&h!==(h=47+v[35]*v[7])&&t(u,"x",h),R[0]&8&&k!==(k=v[3]-10)&&t(u,"y",k),R[0]&128&&g!==(g=45+v[35]*v[7])&&t(E,"x1",g),R[0]&8&&b!==(b=v[3]-25)&&t(E,"y1",b),R[0]&128&&z!==(z=45+v[35]*v[7])&&t(E,"x2",z),R[0]&8&&O!==(O=v[3]-30)&&t(E,"y2",O)},d(v){v&&c(a),v&&c(u),v&&c(E)}}}function wr(e){let a,s,o;return{c(){a=ae("circle"),this.h()},l(n){a=oe(n,"circle",{class:!0,cx:!0,cy:!0,r:!0,fill:!0,stroke:!0,"stroke-width":!0}),p(a).forEach(c),this.h()},h(){t(a,"class","point-white svelte-zm4pmy"),t(a,"cx",s=45+pe([0,se],e[5],parseFloat(e[33][q]))),t(a,"cy",o=30+fe(e[10],e[3]-60,e[33].downtown_recovery)),t(a,"r","6"),t(a,"fill","black"),t(a,"stroke","white"),t(a,"stroke-width","3")},m(n,u){ne(n,a,u)},p(n,u){u[0]&33&&s!==(s=45+pe([0,se],n[5],parseFloat(n[33][q])))&&t(a,"cx",s),u[0]&1033&&o!==(o=30+fe(n[10],n[3]-60,n[33].downtown_recovery))&&t(a,"cy",o)},d(n){n&&c(a)}}}function yr(e){let a=e[33][q]>=0&&!isNaN(parseFloat(e[33][q])),s,o=a&&wr(e);return{c(){o&&o.c(),s=de()},l(n){o&&o.l(n),s=de()},m(n,u){o&&o.m(n,u),ne(n,s,u)},p(n,u){u[0]&1&&(a=n[33][q]>=0&&!isNaN(parseFloat(n[33][q]))),a?o?o.p(n,u):(o=wr(n),o.c(),o.m(s.parentNode,s)):o&&(o.d(1),o=null)},d(n){o&&o.d(n),n&&c(s)}}}function gr(e){let a,s,o,n,u,F;function f(...h){return e[20](e[33],...h)}function A(...h){return e[21](e[33],...h)}return{c(){a=ae("circle"),this.h()},l(h){a=oe(h,"circle",{class:!0,cx:!0,cy:!0,r:!0,fill:!0,stroke:!0,"stroke-width":!0}),p(a).forEach(c),this.h()},h(){t(a,"class","point svelte-zm4pmy"),t(a,"cx",s=45+pe([0,se],e[5],parseFloat(e[33][q]))),t(a,"cy",o=30+fe(e[10],e[3]-60,e[33].downtown_recovery)),t(a,"r","6"),t(a,"fill",n=e[13].find(f).colour),t(a,"stroke","white"),t(a,"stroke-width","0")},m(h,k){ne(h,a,k),u||(F=[hr(a,"mouseover",A),hr(a,"mouseout",e[22])],u=!0)},p(h,k){e=h,k[0]&33&&s!==(s=45+pe([0,se],e[5],parseFloat(e[33][q])))&&t(a,"cx",s),k[0]&1033&&o!==(o=30+fe(e[10],e[3]-60,e[33].downtown_recovery))&&t(a,"cy",o),k[0]&1&&n!==(n=e[13].find(f).colour)&&t(a,"fill",n)},d(h){h&&c(a),u=!1,Cr(F)}}}function br(e){let a=e[33][q]>=0&&!isNaN(parseFloat(e[33][q])),s,o=a&&gr(e);return{c(){o&&o.c(),s=de()},l(n){o&&o.l(n),s=de()},m(n,u){o&&o.m(n,u),ne(n,s,u)},p(n,u){u[0]&1&&(a=n[33][q]>=0&&!isNaN(parseFloat(n[33][q]))),a?o?o.p(n,u):(o=gr(n),o.c(),o.m(s.parentNode,s)):o&&(o.d(1),o=null)},d(n){o&&o.d(n),n&&c(s)}}}function kr(e){let a,s,o,n,u=e[9].city+"",F,f,A,h,k=Math.round(100*e[9].downtown_recovery)+"",E,g,b,z,O=Math.round((100*e[9].transit_recovery).toString())+"",v,R,U,N,X;return{c(){a=ae("foreignObject"),s=w("div"),o=w("p"),n=w("u"),F=m(u),f=T(),A=w("br"),h=m(` 
                            Downtown Recovery: `),E=m(k),g=m(`%
                            `),b=w("br"),z=m(`
                            Transit Recovery: `),v=m(O),R=m("%"),U=T(),this.h()},l(D){a=oe(D,"foreignObject",{x:!0,y:!0,width:!0,height:!0});var I=p(a);s=y(I,"DIV",{id:!0,style:!0,class:!0});var Z=p(s);o=y(Z,"P",{id:!0,class:!0});var H=p(o);n=y(H,"U",{});var M=p(n);F=_(M,u),M.forEach(c),f=C(H),A=y(H,"BR",{}),h=_(H,` 
                            Downtown Recovery: `),E=_(H,k),g=_(H,`%
                            `),b=y(H,"BR",{}),z=_(H,`
                            Transit Recovery: `),v=_(H,O),R=_(H,"%"),H.forEach(c),U=C(Z),Z.forEach(c),I.forEach(c),this.h()},h(){t(o,"id","tooltip-p"),t(o,"class","svelte-zm4pmy"),t(s,"id","tooltip"),Tr(s,"background-color","black"),t(s,"class","svelte-zm4pmy"),t(a,"x",N=(parseFloat(e[9][q])<se/2?0:-175)+55+pe([0,se],e[5],parseFloat(e[9][q]))),t(a,"y",X=22+fe(e[10],e[3]-60,e[9].downtown_recovery)),t(a,"width","155"),t(a,"height","50")},m(D,I){ne(D,a,I),r(a,s),r(s,o),r(o,n),r(n,F),r(o,f),r(o,A),r(o,h),r(o,E),r(o,g),r(o,b),r(o,z),r(o,v),r(o,R),r(s,U)},p(D,I){I[0]&512&&u!==(u=D[9].city+"")&&Ye(F,u),I[0]&512&&k!==(k=Math.round(100*D[9].downtown_recovery)+"")&&Ye(E,k),I[0]&512&&O!==(O=Math.round((100*D[9].transit_recovery).toString())+"")&&Ye(v,O),I[0]&544&&N!==(N=(parseFloat(D[9][q])<se/2?0:-175)+55+pe([0,se],D[5],parseFloat(D[9][q])))&&t(a,"x",N),I[0]&1544&&X!==(X=22+fe(D[10],D[3]-60,D[9].downtown_recovery))&&t(a,"y",X)},d(D){D&&c(a)}}}function Or(e){let a,s,o,n,u,F,f,A,h,k,E,g,b,z,O,v,R,U=e[6].toFixed(3)+"",N,X,D,I,Z,H,M,K,ve,le,x=e[4].reverse(),d=[];for(let i=0;i<x.length;i+=1)d[i]=mr(vr(e,x,i));let ee=[0,1,2,3,4,5,6,7],W=[];for(let i=0;i<8;i+=1)W[i]=_r(pr(e,ee,i));let ue=e[0],B=[];for(let i=0;i<ue.length;i+=1)B[i]=yr(fr(e,ue,i));let V=e[0],$=[];for(let i=0;i<V.length;i+=1)$[i]=br(dr(e,V,i));let L=e[9]!=null&&kr(e);return{c(){a=w("div"),s=w("div"),o=w("h3"),n=m(e[12]),u=m(" Ridership & Downtown Recovery"),F=T(),f=ae("svg");for(let i=0;i<d.length;i+=1)d[i].c();A=de();for(let i=0;i<8;i+=1)W[i].c();h=ae("line");for(let i=0;i<B.length;i+=1)B[i].c();z=de();for(let i=0;i<$.length;i+=1)$[i].c();O=de(),L&&L.c(),v=ae("text"),R=m("Correlation Coefficient: "),N=m(U),D=ae("text"),I=m(e[12]),Z=m(" Ridership Recovery"),K=ae("text"),ve=m("Downtown Recovery"),this.h()},l(i){a=y(i,"DIV",{class:!0});var P=p(a);s=y(P,"DIV",{id:!0,class:!0});var l=p(s);o=y(l,"H3",{class:!0});var j=p(o);n=_(j,e[12]),u=_(j," Ridership & Downtown Recovery"),j.forEach(c),F=C(l),f=oe(l,"svg",{height:!0,width:!0,id:!0,class:!0});var Y=p(f);for(let J=0;J<d.length;J+=1)d[J].l(Y);A=de();for(let J=0;J<8;J+=1)W[J].l(Y);h=oe(Y,"line",{x1:!0,y1:!0,x2:!0,y2:!0,stroke:!0,"stroke-width":!0,"stroke-dasharray":!0}),p(h).forEach(c);for(let J=0;J<B.length;J+=1)B[J].l(Y);z=de();for(let J=0;J<$.length;J+=1)$[J].l(Y);O=de(),L&&L.l(Y),v=oe(Y,"text",{class:!0,x:!0,y:!0,"text-anchor":!0});var ge=p(v);R=_(ge,"Correlation Coefficient: "),N=_(ge,U),ge.forEach(c),D=oe(Y,"text",{class:!0,x:!0,y:!0,"text-anchor":!0});var be=p(D);I=_(be,e[12]),Z=_(be," Ridership Recovery"),be.forEach(c),K=oe(Y,"text",{class:!0,x:!0,y:!0,"text-anchor":!0,transform:!0});var me=p(K);ve=_(me,"Downtown Recovery"),me.forEach(c),Y.forEach(c),l.forEach(c),P.forEach(c),this.h()},h(){t(o,"class","svelte-zm4pmy"),t(h,"x1",k=45+pe([0,se],e[5],parseFloat(e[1][0][0]))),t(h,"y1",E=30+fe(e[10],e[3]-60,parseFloat(e[1][0][1]))),t(h,"x2",g=45+pe([0,se],e[5],parseFloat(e[1][1][0]))),t(h,"y2",b=30+fe(e[10],e[3]-60,parseFloat(e[1][1][1]))),t(h,"stroke","#D0D1C9"),t(h,"stroke-width","1.5"),t(h,"stroke-dasharray","4 2"),t(v,"class","axis-label svelte-zm4pmy"),t(v,"x",X=e[2]/2),t(v,"y",20),t(v,"text-anchor","middle"),t(D,"class","axis-label svelte-zm4pmy"),t(D,"x",H=e[2]/2+14),t(D,"y",M=e[3]-40),t(D,"text-anchor","middle"),t(K,"class","axis-label svelte-zm4pmy"),t(K,"x","300"),t(K,"y",375),t(K,"text-anchor","middle"),t(K,"transform","rotate(-90, 60, 375)"),t(f,"height",e[3]),t(f,"width",e[2]),t(f,"id","chart"),t(f,"class","svelte-zm4pmy"),t(s,"id","chart-wrapper"),t(s,"class","svelte-zm4pmy"),Dr(()=>e[23].call(s)),t(a,"class","text svelte-zm4pmy")},m(i,P){ne(i,a,P),r(a,s),r(s,o),r(o,n),r(o,u),r(s,F),r(s,f);for(let l=0;l<d.length;l+=1)d[l]&&d[l].m(f,null);r(f,A);for(let l=0;l<8;l+=1)W[l]&&W[l].m(f,null);r(f,h);for(let l=0;l<B.length;l+=1)B[l]&&B[l].m(f,null);r(f,z);for(let l=0;l<$.length;l+=1)$[l]&&$[l].m(f,null);r(f,O),L&&L.m(f,null),r(f,v),r(v,R),r(v,N),r(f,D),r(D,I),r(D,Z),r(f,K),r(K,ve),le=Fr(s,e[23].bind(s))},p(i,P){if(P[0]&2068){x=i[4].reverse();let l;for(l=0;l<x.length;l+=1){const j=vr(i,x,l);d[l]?d[l].p(j,P):(d[l]=mr(j),d[l].c(),d[l].m(f,A))}for(;l<d.length;l+=1)d[l].d(1);d.length=x.length}if(P[0]&392){ee=[0,1,2,3,4,5,6,7];let l;for(l=0;l<8;l+=1){const j=pr(i,ee,l);W[l]?W[l].p(j,P):(W[l]=_r(j),W[l].c(),W[l].m(f,h))}for(;l<8;l+=1)W[l].d(1)}if(P[0]&34&&k!==(k=45+pe([0,se],i[5],parseFloat(i[1][0][0])))&&t(h,"x1",k),P[0]&1034&&E!==(E=30+fe(i[10],i[3]-60,parseFloat(i[1][0][1])))&&t(h,"y1",E),P[0]&34&&g!==(g=45+pe([0,se],i[5],parseFloat(i[1][1][0])))&&t(h,"x2",g),P[0]&1034&&b!==(b=30+fe(i[10],i[3]-60,parseFloat(i[1][1][1])))&&t(h,"y2",b),P[0]&1065){ue=i[0];let l;for(l=0;l<ue.length;l+=1){const j=fr(i,ue,l);B[l]?B[l].p(j,P):(B[l]=yr(j),B[l].c(),B[l].m(f,z))}for(;l<B.length;l+=1)B[l].d(1);B.length=ue.length}if(P[0]&26153){V=i[0];let l;for(l=0;l<V.length;l+=1){const j=dr(i,V,l);$[l]?$[l].p(j,P):($[l]=br(j),$[l].c(),$[l].m(f,O))}for(;l<$.length;l+=1)$[l].d(1);$.length=V.length}i[9]!=null?L?L.p(i,P):(L=kr(i),L.c(),L.m(f,v)):L&&(L.d(1),L=null),P[0]&64&&U!==(U=i[6].toFixed(3)+"")&&Ye(N,U),P[0]&4&&X!==(X=i[2]/2)&&t(v,"x",X),P[0]&4&&H!==(H=i[2]/2+14)&&t(D,"x",H),P[0]&8&&M!==(M=i[3]-40)&&t(D,"y",M),P[0]&8&&t(f,"height",i[3]),P[0]&4&&t(f,"width",i[2])},i:zt,o:zt,d(i){i&&c(a),et(d,i),et(W,i),et(B,i),et($,i),L&&L.d(),le()}}}let Br=1.4,q="transit_recovery",se=1.4;function Lr(e,a){let s=[];for(let o=0;o<=Math.ceil(e/a);o++)s.push(o*a);return s}function fe(e,a,s){return a-a*s/(e[1]-e[0])}function pe(e,a,s){return a*s/(e[1]-e[0])}function Wr(e,a,s,o,n,u){let F,f,A,h,k=e*s+a;k>=o&&k<=u?(F=s,f=k):e>0?(F=(o-a)/e,f=o):(F=(u-a)/e,f=u);let E=e*n+a;return E>=o&&E<=u?(A=n,h=E):e>0?(A=(u-a)/e,h=u):(A=(o-a)/e,h=o),[[F,f],[A,h]]}function jr(e,a,s){let o,n,u,F;ur(e,Ir,d=>s(19,u=d)),ur(e,$r,d=>s(28,F=d));let{transitVariable:f}=a;const A=[{id:"MB",name:"Bus",colour:"#6D247A"},{id:"CR",name:"Commuter Rail",colour:"#8DBF2E"},{id:"LR",name:"Light Rail",colour:"#DC4633"},{id:"HR",name:"Subway/Metro",colour:"#6FC7EA"},{id:"Total",name:"Transit",colour:"#6FC7EA"}];let h=A.filter(d=>d.id===f)[0].name;A.filter(d=>d.id===f)[0].colour;let k=[],E=[],g=0,b,z=[[0,0],[1,1]];const O=F;async function v(){try{const ee=await(await fetch("/transit-and-downtown-recovery.csv")).text();s(16,k=Nr(ee)),console.log(k)}catch(d){console.error("Error loading CSV data:",d)}}Pr(()=>{v()});let R,U=420,N=[0,1],X=100,D=.1,I=1,Z;const H=function(d){d.clientX,d.clientY};let M=[];const K=(d,ee)=>ee.name===d.region,ve=(d,ee)=>{s(9,Z=d),H(ee)},le=()=>{s(9,Z=void 0)};function x(){R=this.offsetWidth,s(2,R)}return e.$$set=d=>{"transitVariable"in d&&s(15,f=d.transitVariable)},e.$$.update=()=>{e.$$.dirty[0]&622592&&s(0,E=k.filter(d=>d.mode===f).filter(d=>u.includes(d.region)).sort((d,ee)=>ee.downtown_recovery-d.downtown_recovery)),e.$$.dirty[0]&4&&s(3,U=R*1+20),e.$$.dirty[0]&24&&s(11,o=(U-60)/(N.length-1)),e.$$.dirty[0]&16&&s(10,n=[Math.min(...N),Math.max(...N)]),e.$$.dirty[0]&4&&s(5,X=R-45-10),e.$$.dirty[0]&32&&s(7,D=X/7),e.$$.dirty[0]&1&&s(18,M=E.filter(d=>!isNaN(parseFloat(d[q])))),e.$$.dirty[0]&262144&&console.log(M),e.$$.dirty[0]&262144&&s(6,g=M.length>0?Sr(M.map(d=>parseFloat(d[q])),M.map(d=>parseFloat(d.downtown_recovery))):0),e.$$.dirty[0]&262144&&s(17,b=M.length>0?zr(M.map(d=>[parseFloat(d[q]),parseFloat(d.downtown_recovery)])):null),e.$$.dirty[0]&131088&&s(1,z=b!==null?Wr(b.m,b.b,0,0,se,Math.max(...N)):[[0,0],[1.4,1.4]]),e.$$.dirty[0]&2&&console.log(z),e.$$.dirty[0]&131072&&b!==null&&100*b.m,e.$$.dirty[0]&131072&&b!==null&&100*b.b},s(4,N=Lr(Br,.2)),s(8,I=se/7),[E,z,R,U,N,X,g,D,I,Z,n,o,h,O,H,f,k,b,M,u,K,ve,le,x]}class Ke extends Er{constructor(a){super(),Rr(this,a,jr,Or,Ar,{transitVariable:15},null,[-1,-1])}}function Jr(e){let a,s,o,n,u,F,f,A,h,k,E,g,b,z,O,v,R,U,N,X,D,I,Z,H,M,K,ve,le,x,d,ee,W,ue,B,V,$,L,i,P,l,j,Y,ge,be,me,J,tt,Se,rt,at,ze,ot,st,Ie,nt,lt,$e,it,ct,ie,Ne,ke,ut,He,Ee,ht,Me,Re,dt,Oe,Ae,ft,te,Be,pt,vt,Le,mt,_t,We,wt,yt,je,gt,bt,Je,kt,Et,_e,qe,Rt,At,ce,Dt,Qe,Ft,Pt,Ue,Tt,Ct,Xe,Vt,St,Ge;return a=new Vr({}),R=new Ke({props:{transitVariable:"Total"}}),d=new Hr({props:{europe:"no",canada:"yes"}}),ke=new Ke({props:{transitVariable:"MB"}}),Ee=new Ke({props:{transitVariable:"LR"}}),Re=new Ke({props:{transitVariable:"HR"}}),Ae=new Ke({props:{transitVariable:"CR"}}),{c(){De(a.$$.fragment),s=T(),o=w("main"),n=w("div"),u=w("h3"),F=m("Reviving Downtowns and Transit: A Potential Path to Post-Pandemic Recovery"),f=T(),A=w("p"),h=m("By "),k=w("a"),E=m("Amir Forouhar"),g=m(" | October 31, 2023"),b=T(),z=w("p"),O=m("The Covid-19 pandemic significantly impacted our vibrant city life and downtown areas. As cities aim to recover, the role of public transit in this process has garnered our attention. So, we decided to explore the interplay between recovery of downtown areas and rebound of transit ridership- an exploration that includes commuter rail, heavy rail, light rail, and buses in cities across North America."),v=T(),De(R.$$.fragment),U=T(),N=w("p"),X=m("What we uncovered was a connection between downtown recovery and the resurgence of public transit ridership, including commuter rail, heavy rail, and bus services. It's like a mutual reawakening - as our downtown areas gradually came back to life, people also returned to public transportation as a preferred means of commuting."),D=T(),I=w("p"),Z=m("While it is not a strict cause-and-effect relationship, our data suggests that public transit is an ingredient in the recipe for downtown recovery – that the return to pre-pandemic levels of urban vibrancy is intertwined with a resurgence in public transportation use."),H=T(),M=w("p"),K=m("The colours of the dots on the chart indicate the geographic region of each city. Click below to toggle on/off different regions and the chart will update based on your selection."),ve=T(),le=w("div"),x=w("div"),De(d.$$.fragment),ee=T(),W=w("p"),ue=m("We've also created charts for different modes of transit; busses, light rail, heavy rail (i.e. metro and subway), and commuter rail. Check them out below"),B=T(),V=w("div"),$=w("h4"),L=m("Commuter Rail:"),i=T(),P=w("p"),l=m("For cities with commuter rail systems, we observed a noteworthy connection between downtown recovery and the return of commuters to the rail lines. This suggests that as businesses and offices reopen, commuters are once again using this mode of transit to access downtown job centres."),j=T(),Y=w("h4"),ge=m("Heavy rail (subway/metro):"),be=T(),me=w("p"),J=m("The use of heavy rail systems, such as subways or metros, also indicates a correlation with the resurgence of downtown areas. These systems often offer the most straightforward transit access to urban centres, and it's clear that they contribute much to city life."),tt=T(),Se=w("h4"),rt=m("Light Rail:"),at=T(),ze=w("p"),ot=m("Light rail, while a crucial part of public transportation, complicates the story, as we found a less significant relationship between its use and downtown recovery. This may be due to issues of accessibility/coverage or commuter preferences – it is something that we will continue to monitor and think through."),st=T(),Ie=w("h4"),nt=m("Bus services:"),lt=T(),$e=w("p"),it=m("Buses, often considered the backbone of urban transit systems, showed a clear connection with downtown recovery. As people return to shops, restaurants, and cultural attractions, buses offer accessible and adaptable options for reaching downtowns."),ct=T(),ie=w("div"),Ne=w("div"),De(ke.$$.fragment),ut=T(),He=w("div"),De(Ee.$$.fragment),ht=T(),Me=w("div"),De(Re.$$.fragment),dt=T(),Oe=w("div"),De(Ae.$$.fragment),ft=T(),te=w("div"),Be=w("h4"),pt=m("Conclusion"),vt=T(),Le=w("p"),mt=m("Our data analysis makes it clear that a return to the liveliness of pre-pandemic downtowns is linked to a resurgence in public transit use. As downtowns across North America bounce back slowly, public transit serves as a cohesive, sustainable, and efficient element."),_t=T(),We=w("p"),wt=m("The discernible relationship between downtown recovery and transit ridership recovery presents cities with a potential path to post-pandemic success. This relationship supports arguments for further investment in public transportation systems, demonstrating that thriving downtowns and robust transit networks are closely intertwined."),yt=T(),je=w("p"),gt=m("However, it is important to acknowledge that the role of light rail in this dynamic is less clear and may require extra tailored strategies and enhancements to fully unlock its potential."),bt=T(),Je=w("p"),kt=m("The road ahead for downtowns contains ongoing challenges, but the connection between recovery and ridership provides a clear example of a way forward."),Et=T(),_e=w("div"),qe=w("h4"),Rt=m("Data Sources"),At=T(),ce=w("p"),Dt=m("We obtained our transit ridership data from the "),Qe=w("a"),Ft=m("American Public Transportation Association (APTA) Ridership Report"),Pt=m(". APTA’s Quarterly Ridership Report contains information on the number of unlinked passenger trips taken on public transportation, broken down by agency and mode. Our analysis specifically concentrated on the period from January to June 2023, comparing it to the reference period in 2019. For details on the downtown recovery metrics, check out our "),Ue=w("a"),Tt=m("methodology"),Ct=m(". The charts on this page were made by "),Xe=w("a"),Vt=m("Jeff Allen"),St=m(" using D3 and Svelte."),this.h()},l(S){Fe(a.$$.fragment,S),s=C(S),o=y(S,"MAIN",{});var re=p(o);n=y(re,"DIV",{class:!0});var Q=p(n);u=y(Q,"H3",{});var It=p(u);F=_(It,"Reviving Downtowns and Transit: A Potential Path to Post-Pandemic Recovery"),It.forEach(c),f=C(Q),A=y(Q,"P",{class:!0});var Ze=p(A);h=_(Ze,"By "),k=y(Ze,"A",{href:!0});var $t=p(k);E=_($t,"Amir Forouhar"),$t.forEach(c),g=_(Ze," | October 31, 2023"),Ze.forEach(c),b=C(Q),z=y(Q,"P",{class:!0});var Nt=p(z);O=_(Nt,"The Covid-19 pandemic significantly impacted our vibrant city life and downtown areas. As cities aim to recover, the role of public transit in this process has garnered our attention. So, we decided to explore the interplay between recovery of downtown areas and rebound of transit ridership- an exploration that includes commuter rail, heavy rail, light rail, and buses in cities across North America."),Nt.forEach(c),v=C(Q),Fe(R.$$.fragment,Q),U=C(Q),N=y(Q,"P",{class:!0});var Ht=p(N);X=_(Ht,"What we uncovered was a connection between downtown recovery and the resurgence of public transit ridership, including commuter rail, heavy rail, and bus services. It's like a mutual reawakening - as our downtown areas gradually came back to life, people also returned to public transportation as a preferred means of commuting."),Ht.forEach(c),D=C(Q),I=y(Q,"P",{class:!0});var Mt=p(I);Z=_(Mt,"While it is not a strict cause-and-effect relationship, our data suggests that public transit is an ingredient in the recipe for downtown recovery – that the return to pre-pandemic levels of urban vibrancy is intertwined with a resurgence in public transportation use."),Mt.forEach(c),H=C(Q),M=y(Q,"P",{class:!0});var Ot=p(M);K=_(Ot,"The colours of the dots on the chart indicate the geographic region of each city. Click below to toggle on/off different regions and the chart will update based on your selection."),Ot.forEach(c),ve=C(Q),le=y(Q,"DIV",{id:!0,class:!0});var Bt=p(le);x=y(Bt,"DIV",{id:!0});var Lt=p(x);Fe(d.$$.fragment,Lt),Lt.forEach(c),Bt.forEach(c),ee=C(Q),W=y(Q,"P",{class:!0});var Wt=p(W);ue=_(Wt,"We've also created charts for different modes of transit; busses, light rail, heavy rail (i.e. metro and subway), and commuter rail. Check them out below"),Wt.forEach(c),Q.forEach(c),B=C(re),V=y(re,"DIV",{class:!0});var G=p(V);$=y(G,"H4",{class:!0});var jt=p($);L=_(jt,"Commuter Rail:"),jt.forEach(c),i=C(G),P=y(G,"P",{class:!0});var Jt=p(P);l=_(Jt,"For cities with commuter rail systems, we observed a noteworthy connection between downtown recovery and the return of commuters to the rail lines. This suggests that as businesses and offices reopen, commuters are once again using this mode of transit to access downtown job centres."),Jt.forEach(c),j=C(G),Y=y(G,"H4",{class:!0});var qt=p(Y);ge=_(qt,"Heavy rail (subway/metro):"),qt.forEach(c),be=C(G),me=y(G,"P",{class:!0});var Qt=p(me);J=_(Qt,"The use of heavy rail systems, such as subways or metros, also indicates a correlation with the resurgence of downtown areas. These systems often offer the most straightforward transit access to urban centres, and it's clear that they contribute much to city life."),Qt.forEach(c),tt=C(G),Se=y(G,"H4",{class:!0});var Ut=p(Se);rt=_(Ut,"Light Rail:"),Ut.forEach(c),at=C(G),ze=y(G,"P",{class:!0});var Xt=p(ze);ot=_(Xt,"Light rail, while a crucial part of public transportation, complicates the story, as we found a less significant relationship between its use and downtown recovery. This may be due to issues of accessibility/coverage or commuter preferences – it is something that we will continue to monitor and think through."),Xt.forEach(c),st=C(G),Ie=y(G,"H4",{class:!0});var Yt=p(Ie);nt=_(Yt,"Bus services:"),Yt.forEach(c),lt=C(G),$e=y(G,"P",{class:!0});var Kt=p($e);it=_(Kt,"Buses, often considered the backbone of urban transit systems, showed a clear connection with downtown recovery. As people return to shops, restaurants, and cultural attractions, buses offer accessible and adaptable options for reaching downtowns."),Kt.forEach(c),G.forEach(c),ct=C(re),ie=y(re,"DIV",{class:!0});var we=p(ie);Ne=y(we,"DIV",{class:!0});var Gt=p(Ne);Fe(ke.$$.fragment,Gt),Gt.forEach(c),ut=C(we),He=y(we,"DIV",{class:!0});var Zt=p(He);Fe(Ee.$$.fragment,Zt),Zt.forEach(c),ht=C(we),Me=y(we,"DIV",{class:!0});var xt=p(Me);Fe(Re.$$.fragment,xt),xt.forEach(c),dt=C(we),Oe=y(we,"DIV",{class:!0});var er=p(Oe);Fe(Ae.$$.fragment,er),er.forEach(c),we.forEach(c),ft=C(re),te=y(re,"DIV",{class:!0});var he=p(te);Be=y(he,"H4",{class:!0});var tr=p(Be);pt=_(tr,"Conclusion"),tr.forEach(c),vt=C(he),Le=y(he,"P",{class:!0});var rr=p(Le);mt=_(rr,"Our data analysis makes it clear that a return to the liveliness of pre-pandemic downtowns is linked to a resurgence in public transit use. As downtowns across North America bounce back slowly, public transit serves as a cohesive, sustainable, and efficient element."),rr.forEach(c),_t=C(he),We=y(he,"P",{class:!0});var ar=p(We);wt=_(ar,"The discernible relationship between downtown recovery and transit ridership recovery presents cities with a potential path to post-pandemic success. This relationship supports arguments for further investment in public transportation systems, demonstrating that thriving downtowns and robust transit networks are closely intertwined."),ar.forEach(c),yt=C(he),je=y(he,"P",{class:!0});var or=p(je);gt=_(or,"However, it is important to acknowledge that the role of light rail in this dynamic is less clear and may require extra tailored strategies and enhancements to fully unlock its potential."),or.forEach(c),bt=C(he),Je=y(he,"P",{class:!0});var sr=p(Je);kt=_(sr,"The road ahead for downtowns contains ongoing challenges, but the connection between recovery and ridership provides a clear example of a way forward."),sr.forEach(c),he.forEach(c),Et=C(re),_e=y(re,"DIV",{class:!0});var xe=p(_e);qe=y(xe,"H4",{class:!0});var nr=p(qe);Rt=_(nr,"Data Sources"),nr.forEach(c),At=C(xe),ce=y(xe,"P",{class:!0});var ye=p(ce);Dt=_(ye,"We obtained our transit ridership data from the "),Qe=y(ye,"A",{href:!0});var lr=p(Qe);Ft=_(lr,"American Public Transportation Association (APTA) Ridership Report"),lr.forEach(c),Pt=_(ye,". APTA’s Quarterly Ridership Report contains information on the number of unlinked passenger trips taken on public transportation, broken down by agency and mode. Our analysis specifically concentrated on the period from January to June 2023, comparing it to the reference period in 2019. For details on the downtown recovery metrics, check out our "),Ue=y(ye,"A",{href:!0});var ir=p(Ue);Tt=_(ir,"methodology"),ir.forEach(c),Ct=_(ye,". The charts on this page were made by "),Xe=y(ye,"A",{href:!0});var cr=p(Xe);Vt=_(cr,"Jeff Allen"),cr.forEach(c),St=_(ye," using D3 and Svelte."),ye.forEach(c),xe.forEach(c),re.forEach(c),this.h()},h(){t(k,"href","www.linkedin.com/in/amir-forouhar"),t(A,"class","svelte-155wbko"),t(z,"class","svelte-155wbko"),t(N,"class","svelte-155wbko"),t(I,"class","svelte-155wbko"),t(M,"class","svelte-155wbko"),t(x,"id","options-region"),t(le,"id","options"),t(le,"class","svelte-155wbko"),t(W,"class","svelte-155wbko"),t(n,"class","text svelte-155wbko"),t($,"class","svelte-155wbko"),t(P,"class","svelte-155wbko"),t(Y,"class","svelte-155wbko"),t(me,"class","svelte-155wbko"),t(Se,"class","svelte-155wbko"),t(ze,"class","svelte-155wbko"),t(Ie,"class","svelte-155wbko"),t($e,"class","svelte-155wbko"),t(V,"class","text svelte-155wbko"),t(Ne,"class","grid-cell svelte-155wbko"),t(He,"class","grid-cell svelte-155wbko"),t(Me,"class","grid-cell svelte-155wbko"),t(Oe,"class","grid-cell svelte-155wbko"),t(ie,"class","grid svelte-155wbko"),t(Be,"class","svelte-155wbko"),t(Le,"class","svelte-155wbko"),t(We,"class","svelte-155wbko"),t(je,"class","svelte-155wbko"),t(Je,"class","svelte-155wbko"),t(te,"class","text svelte-155wbko"),t(qe,"class","svelte-155wbko"),t(Qe,"href","https://www.apta.com/research-technical-resources/transit-statistics/ridership-report/"),t(Ue,"href","../methodology"),t(Xe,"href","https://jamaps.github.io"),t(ce,"class","svelte-155wbko"),t(_e,"class","text svelte-155wbko")},m(S,re){Pe(a,S,re),ne(S,s,re),ne(S,o,re),r(o,n),r(n,u),r(u,F),r(n,f),r(n,A),r(A,h),r(A,k),r(k,E),r(A,g),r(n,b),r(n,z),r(z,O),r(n,v),Pe(R,n,null),r(n,U),r(n,N),r(N,X),r(n,D),r(n,I),r(I,Z),r(n,H),r(n,M),r(M,K),r(n,ve),r(n,le),r(le,x),Pe(d,x,null),r(n,ee),r(n,W),r(W,ue),r(o,B),r(o,V),r(V,$),r($,L),r(V,i),r(V,P),r(P,l),r(V,j),r(V,Y),r(Y,ge),r(V,be),r(V,me),r(me,J),r(V,tt),r(V,Se),r(Se,rt),r(V,at),r(V,ze),r(ze,ot),r(V,st),r(V,Ie),r(Ie,nt),r(V,lt),r(V,$e),r($e,it),r(o,ct),r(o,ie),r(ie,Ne),Pe(ke,Ne,null),r(ie,ut),r(ie,He),Pe(Ee,He,null),r(ie,ht),r(ie,Me),Pe(Re,Me,null),r(ie,dt),r(ie,Oe),Pe(Ae,Oe,null),r(o,ft),r(o,te),r(te,Be),r(Be,pt),r(te,vt),r(te,Le),r(Le,mt),r(te,_t),r(te,We),r(We,wt),r(te,yt),r(te,je),r(je,gt),r(te,bt),r(te,Je),r(Je,kt),r(o,Et),r(o,_e),r(_e,qe),r(qe,Rt),r(_e,At),r(_e,ce),r(ce,Dt),r(ce,Qe),r(Qe,Ft),r(ce,Pt),r(ce,Ue),r(Ue,Tt),r(ce,Ct),r(ce,Xe),r(Xe,Vt),r(ce,St),Ge=!0},p:zt,i(S){Ge||(Te(a.$$.fragment,S),Te(R.$$.fragment,S),Te(d.$$.fragment,S),Te(ke.$$.fragment,S),Te(Ee.$$.fragment,S),Te(Re.$$.fragment,S),Te(Ae.$$.fragment,S),Ge=!0)},o(S){Ce(a.$$.fragment,S),Ce(R.$$.fragment,S),Ce(d.$$.fragment,S),Ce(ke.$$.fragment,S),Ce(Ee.$$.fragment,S),Ce(Re.$$.fragment,S),Ce(Ae.$$.fragment,S),Ge=!1},d(S){Ve(a,S),S&&c(s),S&&c(o),Ve(R),Ve(d),Ve(ke),Ve(Ee),Ve(Re),Ve(Ae)}}}class Zr extends Er{constructor(a){super(),Rr(this,a,null,Jr,Ar,{})}}export{Zr as component,Gr as universal};