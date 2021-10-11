libname asis5 "/var/opt/analysis_5";

data asis5.Det_interaction_format;
input fmtname $ start $ label $ type $;
datalines;
reasonid 1193 10 c
reasonid 1194 5 c
reasonid 1195 5 c
reasonid 1196 7 c
reasonid 1197 4 c
reasonid 1198 8 c
reasonid 1199 3 c
reasonid 1200 3 c
reasonid 1201 3 c
reasonid 1202 3 c
reasonid 1203 6 c
reasonid 1204 11 c
reasonid 1205 D c
reasonid 1206 5 c
reasonid 1207 5 c
reasonid 1208 9 c
reasonid 1209 5 c
reasonid 1210 5 c
reasonid 1211 7 c
reasonid 1212 10 c
reasonid 1213 10 c
reasonid 1214 10 c
reasonid 1215 1 c
reasonid 1216 1 c
reasonid 1217 1 c
reasonid 1218 1 c
reasonid 1219 7 c
reasonid 1220 1 c
reasonid 1221 1 c
reasonid 1222 10 c
reasonid 1223 10 c
reasonid 1224 10 c
reasonid 1225 10 c
reasonid 1226 9 c
reasonid 1227 4 c
reasonid 1228 4 c
reasonid 1229 4 c
reasonid 1230 4 c
reasonid 1231 4 c
reasonid 1232 4 c
reasonid 1233 4 c
reasonid 1234 8 c
reasonid 1235 8 c
reasonid 1236 8 c
reasonid 1237 8 c
reasonid 1238 4 c
reasonid 1239 1 c
reasonid 1240 2 c
reasonid 1241 10 c
reasonid 1242 4 c
reasonid 1243 2 c
reasonid 1244 8 c
reasonid 1245 8 c
reasonid 1246 4 c
reasonid 1247 3 c
reasonid 1248 5 c
reasonid 1249 10 c
reasonid 1250 9 c
reasonid 1251 1 c
reasonid 1252 9 c
reasonid 1253 5 c
reasonid 1254 5 c
reasonid 1255 5 c
reasonid 1256 2 c
reasonid 1257 4 c
reasonid 1258 8 c
reasonid 1259 10 c
reasonid 1260 10 c
reasonid 1261 3 c
reasonid 1262 3 c
reasonid 1263 3 c
reasonid 1264 10 c
reasonid 1265 5 c
reasonid 1266 9 c
reasonid 1267 10 c
reasonid 1268 7 c
reasonid 1269 1 c
reasonid 1270 5 c
reasonid 1271 D c
reasonid 1272 3 c
reasonid 1273 D c
reasonid 1274 9 c
reasonid 1275 3 c
reasonid 1276 9 c
reasonid 1277 9 c
reasonid 1278 D c
reasonid 1279 D c
reasonid 1280 7 c
reasonid 1281 4 c
reasonid 1282 5 c
reasonid 1283 4 c
reasonid 1284 7 c
reasonid 1285 3 c
reasonid 1286 10 c
reasonid 1287 D c
reasonid 1288 D c
reasonid 1289 D c
reasonid 1290 7 c
reasonid 1291 8 c
reasonid 1292 3 c
reasonid 1293 6 c
reasonid 1294 3 c
reasonid 1295 9 c
reasonid 1296 7 c
reasonid 1297 9 c
reasonid 1298 3 c
reasonid 1299 9 c
reasonid 1300 10 c
reasonid 1301 5 c
reasonid 1302 5 c
reasonid 1303 5 c
reasonid 1304 5 c
reasonid 1305 D c
reasonid 1306 D c
reasonid 1307 D c
reasonid 1308 D c
reasonid 1309 D c
reasonid 1310 D c
reasonid 1311 D c
reasonid 1312 D c
reasonid 1313 7 c
reasonid 1314 D c
reasonid 1315 D c
reasonid 1316 D c
reasonid 1317 D c
reasonid 1318 D c
reasonid 1319 D c
reasonid 1320 D c
reasonid 1321 D c
reasonid 1322 7 c
reasonid 1323 D c
reasonid 1324 D c
reasonid 1325 1 c
reasonid 1326 D c
reasonid 1327 D c
reasonid 1328 D c
reasonid 1329 D c
reasonid 1330 7 c
reasonid 1331 D c
reasonid 1332 10 c
reasonid 1333 9 c
reasonid 1334 D c
reasonid 1335 D c
reasonid 1336 2 c
reasonid 1337 5 c
reasonid 1338 5 c
methodid 1167 1 c
methodid 1168 1 c
methodid 1169 1 c
methodid 1170 1 c
methodid 1171 D c
methodid 1172 2 c
methodid 1173 2 c
methodid 1174 2 c
methodid 1175 2 c
methodid 1176 2 c
methodid 1177 2 c
methodid 1178 3 c
methodid 1179 3 c
methodid 1180 3 c
methodid 1181 2 c
methodid 1182 D c
methodid 1183 1 c
methodid 1184 1 c
methodid 1185 1 c
methodid 1186 1 c
methodid 1187 1 c
methodid 1188 D c
methodid 1189 D c
methodid 1190 1 c
methodid 1191 D c
methodid 1192 D c
methodid 1193 1 c
methodid 1194 1 c
methodid 1195 1 c
methodid 1196 1 c
methodid 1197 1 c
methodid 1198 1 c
methodid 1199 1 c
methodid 1200 1 c
methodid 1201 D c
methodid 1202 2 c
methodid 1203 2 c
methodid 1204 2 c
methodid 1205 2 c
methodid 1206 2 c
methodid 1207 2 c
methodid 1208 2 c
methodid 1209 2 c
methodid 1210 2 c
methodid 1211 2 c
methodid 1212 2 c
methodid 1213 2 c
methodid 1214 2 c
methodid 1215 1 c
methodid 1216 1 c
methodid 1217 2 c
methodid 1218 1 c
methodid 1219 1 c
methodid 1220 D c
;
run;



DATA reasonid (keep = fmtname start label ); 
LENGTH LABEL $20; 
SET asis5.det_interaction_format 
(where = (fmtname = "reasonid")); 
FMTNAME = "reasonid"; 
START = start; 
LABEL = label; 
RUN;

proc sort data = reasonid nodupkey;	by start; run;

PROC FORMAT cntlin = reasonid; 
RUN; 
