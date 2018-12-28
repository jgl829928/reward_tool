include("func.jl")

const jobs = Channel{Int}(32);
const results = Channel{Tuple}(32);
sucRid=[]
faliedRid=[]
ridAry=rid()
rewardData=rewardInfo()
# 放入入通道
@async mytask(ridAry);
# 4个线程，执行任务
for item in 1:4
    @async do_work(ridAry,rewardData)
end
# 读取结果
for i in 1:size(ridAry,1)
    result, time = take!(results)
    println("$result finished in $time seconds")

    result=split(result,".")
    if result[2]=="success"
        push!(sucRid,result[1]) 
    else 
        push!(faliedRid,result[1]) 
    end
end
# 写入数据
writeRes("success.csv",sucRid)
writeRes("failed.csv",faliedRid)

