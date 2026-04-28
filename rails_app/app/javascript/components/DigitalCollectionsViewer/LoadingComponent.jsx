import React from "react";
export default function LoadingComponent(){
    return(
            <div className="d-flex flex-column mb-3">
                <div className="align-self-center placeholder placeholder-wave"  style={{width: "250px", height: "400px"}}/>
                <div className="d-flex flex-row justify-content-center" style={{padding: "1.618rem 0px", gap: "0.4rem"}}>
                    <div className="placeholder placeholder-wave" style={{height: "100px", width: "161.8px"}}/>
                    <div className="placeholder placeholder-wave" style={{height: "100px", width: "161.8px"}}/>
                    <div className="placeholder placeholder-wave" style={{height: "100px", width: "161.8px"}}/>
                    <div className="placeholder placeholder-wave" style={{height: "100px", width: "161.8px"}}/>
                    <div className="placeholder placeholder-wave" style={{height: "100px", width: "161.8px"}}/>
                    <div className="placeholder placeholder-wave" style={{height: "100px", width: "161.8px"}}/>
                </div>
            </div>
    )
}