*** Variables ***
#${MoY}    MoY
${MoY}    {dt:%B} {dt.year}
#${HMS}    H:M:S
${HMS}    {dt:%H}:{dt:%M}:{dt:%S}
#${HM}    H:M
${HM}    {dt:%H}:{dt:%M}
${MDYYYY_ADDSUB}    %m/%d/%Y
${DDMMYYYY_ADDSUB}    %d/%m/%Y
${MDYYYY_NOW}    {dt:%m}/{dt:%d}/{dt:%Y}
${DDMMYYYY_NOW}    {dt:%d}/{dt:%m}/{dt:%Y}
#22012000113011
${DDMMYYYYHMS_NOW}    {dt:%d}{dt:%m}{dt:%Y}{dt:%H}{dt:%M}{dt:%S}
#2021-01-11T03:14:18.255Z
${YYYYMMDDTHMSZ}    %Y-%m-%dT%H:%M:%S.000Z
#2021-01-11T03:14:18.255Z
${YYYYMMDDTHMSZ_FROM_NOW}    %Y-%m-%dT%H:%M:%S.000Z
#${YYYYMMDDTHMSZ_FROM_NOW}    {dt:%Y}-{dt:%m}-{dt:%d}T{dt:%H}:{dt:%M}:{dt:%S}.000Z
#${YYYYMMDDTHMSZ_FROM_NOW}    {dt:%Y}-{dt:%m}-{dt:%d}T00:00:00.000Z
#2021-01-11T03:59:59.999Z
${YYYYMMDDTHMSZ_TO_NOW}    %Y-%m-%dT%H:%M:%S.999Z
#${YYYYMMDDTHMSZ_TO_NOW}    {dt:%Y}-{dt:%m}-{dt:%d}T{dt:%H}:{dt:%M}:{dt:%S}.999Z
#${YYYYMMDDTHMSZ_TO_NOW}    {dt:%Y}-{dt:%m}-{dt:%d}T23:59:59.999Z
#Workin time button home
${DATE_LBL_NOW_TH}    - ตอนนี้
${DATE_LBL_NOW_EN}    -now

${DATE_TYPE_ADD}    add
${DATE_TYPE_SUBTRACT}    subtract

${TIME_STRING_HOURS}    hours
${TIME_STRING_MINUTES}    minutes
${TIME_STRING_SECONDS}    seconds
${TIME_STRING_DAYS}    days

${RANGE_SEARCH}    1