using CSV , DataFrames

function rewardInfo()
    mydata = CSV.read("TestReward.csv")
    nrows, ncols = size(mydata)
    for col in 1:ncols
        if  occursin("INT_REWARD_TYPE", String(names(mydata)[col]))
            println(mydata[1,col])
        end
    end
end

rewardInfo()

